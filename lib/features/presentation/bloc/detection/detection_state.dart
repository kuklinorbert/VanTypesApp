part of 'detection_bloc.dart';

@immutable
abstract class DetectionState extends Equatable {
  const DetectionState();

  @override
  List<Object> get props => [];
}

class DetectionInitial extends DetectionState {}

class LoadedModelState extends DetectionState {}

class PredictingState extends DetectionState {}

class Prediction extends DetectionState {
  final List prediction;

  Prediction({@required this.prediction});

  @override
  List<Object> get props => [prediction];
}

class CameraPermissionGrantedState extends DetectionState {}

class StoragePermissionGrantedState extends DetectionState {}

class PermissionDeniedState extends DetectionState {
  final String message;

  PermissionDeniedState({@required this.message});

  @override
  List<Object> get props => [message];
}

class ImageLoadingState extends DetectionState {}

class ImageLoadedState extends DetectionState {}

class ErrorState extends DetectionState {
  final String message;

  ErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
