part of 'classification_bloc.dart';

@immutable
abstract class ClassificationEvent extends Equatable {
  const ClassificationEvent();

  @override
  List<Object> get props => [];
}

class LoadModelEvent extends ClassificationEvent {}

class CheckStoragePermissionEvent extends ClassificationEvent {}

class CheckCameraPermissionEvent extends ClassificationEvent {}

class PermissionDeniedEvent extends ClassificationEvent {}

class TakeImageEvent extends ClassificationEvent {}

class PickGalleryEvent extends ClassificationEvent {}

class PredictEvent extends ClassificationEvent {
  final File image;

  PredictEvent({@required this.image});

  @override
  List<Object> get props => [image];
}
