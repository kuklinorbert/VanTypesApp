part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends RegistrationEvent {
  final String userName;
  final String email;
  final String password;

  RegisterEvent(
      {@required this.userName, @required this.email, @required this.password});

  List<Object> get props => [userName, email, password];
}
