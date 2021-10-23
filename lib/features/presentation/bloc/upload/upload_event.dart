part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class UploadImageEvent extends UploadEvent {
  final File image;
  final String type;

  UploadImageEvent({@required this.image, @required this.type});

  @override
  List<Object> get props => [image, type];
}

class UploadResetEvent extends UploadEvent {}
