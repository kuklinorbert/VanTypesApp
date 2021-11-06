import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/usecases/detection/check_camera_permission.dart';
import 'package:vantypesapp/features/domain/usecases/detection/check_storage_permission.dart';
import 'package:vantypesapp/features/domain/usecases/detection/load_model.dart';
import 'package:vantypesapp/features/domain/usecases/detection/pick_gallery.dart';
import 'package:vantypesapp/features/domain/usecases/detection/predict.dart';
import 'package:vantypesapp/features/domain/usecases/detection/take_image.dart';

part 'detection_event.dart';
part 'detection_state.dart';

class DetectionBloc extends Bloc<DetectionEvent, DetectionState> {
  final CheckCameraPermission _checkCameraPermission;
  final CheckStoragePermission _checkStoragePermission;
  final LoadModel _loadModel;
  final PickGallery _pickGallery;
  final Predict _predict;
  final TakeImage _takeImage;

  File img;
  double imgW = 0;
  double imgH = 0;

  DetectionBloc(
      {@required CheckCameraPermission checkCameraPermission,
      @required CheckStoragePermission checkStoragePermission,
      @required LoadModel loadModel,
      @required PickGallery pickGallery,
      @required Predict predict,
      @required TakeImage takeImage})
      : assert(predict != null),
        _checkCameraPermission = checkCameraPermission,
        _checkStoragePermission = checkStoragePermission,
        _loadModel = loadModel,
        _pickGallery = pickGallery,
        _predict = predict,
        _takeImage = takeImage,
        super(DetectionInitial());

  @override
  Stream<DetectionState> mapEventToState(
    DetectionEvent event,
  ) async* {
    if (event is LoadModelEvent) {
      final result = await _loadModel.call(NoParams());
      yield* _eitherModelOrError(result);
    } else if (event is CheckCameraPermissionEvent) {
      final perm = await _checkCameraPermission.call(NoParams());
      yield* _eitherCameraPermissionOrError(perm);
    } else if (event is CheckStoragePermissionEvent) {
      final perm = await _checkStoragePermission.call(NoParams());
      yield* _eitherStoragePermissionOrError(perm);
    } else if (event is TakeImageEvent) {
      yield ImageLoadingState();
      final img = await _takeImage.call(NoParams());
      yield* _eitherImageOrError(img);
    } else if (event is PickGalleryEvent) {
      yield ImageLoadingState();
      final img = await _pickGallery.call(NoParams());
      yield* _eitherImageOrError(img);
    } else if (event is PredictEvent) {
      yield PredictingState();
      final prediction = await _predict.call(Params(file: event.image));
      yield* _eitherPredictionOrError(prediction);
    } else if (event is PermissionDeniedEvent) {
      yield LoadedModelState();
    } else if (event is RestartEvent) {
      yield LoadedModelState();
    }
  }

  Stream<DetectionState> _eitherPredictionOrError(
    Either<Failure, List> permissionOrDownload,
  ) async* {
    yield permissionOrDownload.fold(
      (failure) => ErrorState(message: _mapFailureToMessage(failure)),
      (model) {
        return Prediction(prediction: model);
      },
    );
  }

  Stream<DetectionState> _eitherImageOrError(
    Either<Failure, List> permissionOrDownload,
  ) async* {
    yield permissionOrDownload.fold(
      (failure) {
        return ErrorState(message: _mapFailureToMessage(failure));
      },
      (image) {
        img = File(image[0]);
        imgW = image[1];
        imgH = image[2];
        return ImageLoadedState();
      },
    );
  }

  Stream<DetectionState> _eitherModelOrError(
    Either<Failure, String> permissionOrDownload,
  ) async* {
    yield permissionOrDownload.fold(
      (failure) => ErrorState(message: _mapFailureToMessage(failure)),
      (model) {
        return LoadedModelState();
      },
    );
  }

  Stream<DetectionState> _eitherStoragePermissionOrError(
    Either<Failure, PermissionStatus> permissionOrDownload,
  ) async* {
    yield permissionOrDownload.fold(
      (failure) {
        return PermissionDeniedState(message: _mapFailureToMessage(failure));
      },
      (permission) {
        return StoragePermissionGrantedState();
      },
    );
  }

  Stream<DetectionState> _eitherCameraPermissionOrError(
    Either<Failure, PermissionStatus> permissionOrDownload,
  ) async* {
    yield permissionOrDownload.fold(
      (failure) => ErrorState(message: _mapFailureToMessage(failure)),
      (permission) {
        return CameraPermissionGrantedState();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case LoadModelFailure:
        return 'failed to load the model';
      case ImageFailure:
        return 'failed to pick image';
      case PredictionFailure:
        return 'prediction fail';
      case PermissionFailure:
        return 'no permissions';
      default:
        return 'unexpected error';
    }
  }
}
