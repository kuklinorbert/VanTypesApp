part of 'upload_bloc.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class UploadInitial extends UploadState {}

class UploadingState extends UploadState {}

class UploadCompleteState extends UploadState {}

class UploadErrorState extends UploadState {
  final String message;

  UploadErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
