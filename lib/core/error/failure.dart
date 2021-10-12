import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadModelFailure extends Failure {}

class PermissionFailure extends Failure {}

class ImageFailure extends Failure {}

class PredictionFailure extends Failure {}
