part of 'detection_bloc.dart';

@immutable
abstract class DetectionEvent extends Equatable {
  const DetectionEvent();

  @override
  List<Object> get props => [];
}

class LoadModelEvent extends DetectionEvent {}

class CheckStoragePermissionEvent extends DetectionEvent {}

class CheckCameraPermissionEvent extends DetectionEvent {}

class PermissionDeniedEvent extends DetectionEvent {}

class TakeImageEvent extends DetectionEvent {}

class PickGalleryEvent extends DetectionEvent {}

class PredictEvent extends DetectionEvent {
  final String image;

  PredictEvent({@required this.image});

  @override
  List<Object> get props => [image];
}

class RestartEvent extends DetectionEvent {}
