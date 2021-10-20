part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationError extends RegistrationState {
  final String message;

  RegistrationError({@required this.message});

  @override
  List<Object> get props => [message];
}
