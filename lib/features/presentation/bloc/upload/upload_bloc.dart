import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/usecases/upload/upload_image.dart'
    as upload;
import 'package:easy_localization/easy_localization.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final upload.UploadImage _uploadImage;

  UploadBloc({@required upload.UploadImage uploadImage})
      : _uploadImage = uploadImage,
        super(UploadInitial());

  @override
  Stream<UploadState> mapEventToState(UploadEvent event) async* {
    if (event is UploadImageEvent) {
      yield UploadingState();
      final failureOrUpload = await _uploadImage
          .call(upload.Params(image: event.image, type: event.type));
      yield* _eitherUploadedOrErrorState(failureOrUpload);
    } else if (event is UploadResetEvent) {
      yield UploadInitial();
    }
  }

  Stream<UploadState> _eitherUploadedOrErrorState(
    Either<Failure, String> failureOrUpload,
  ) async* {
    yield failureOrUpload.fold(
        (failure) => UploadErrorState(message: _mapFailureToMessage(failure)),
        (response) => UploadCompleteState());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return "network_fail".tr();
      case UploadFailure:
        return "upload_fail".tr();
      default:
        return 'unexp_fail'.tr();
    }
  }
}
