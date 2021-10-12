part of 'classification_bloc.dart';

@immutable
abstract class ClassificationState extends Equatable {
  const ClassificationState();

  @override
  List<Object> get props => [];
}

class ClassificationInitial extends ClassificationState {}

class LoadingModelState extends ClassificationState {}

class LoadedModel extends ClassificationState {}

class PredictingState extends ClassificationState {}

class Prediction extends ClassificationState {
  final List prediction;

  Prediction({@required this.prediction});

  @override
  List<Object> get props => [prediction];
}

class CameraPermissionGranted extends ClassificationState {}

class StoragePermissionGranted extends ClassificationState {}

class PermissionDenied extends ClassificationState {
  final String message;

  PermissionDenied({@required this.message});

  @override
  List<Object> get props => [message];
}

class ImageLoading extends ClassificationState {}

class ImageLoaded extends ClassificationState {
  final List image;

  ImageLoaded({@required this.image});

  @override
  List<Object> get props => [image];
}

class ErrorState extends ClassificationState {
  final String message;

  ErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
