part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  LoginEvent({@required this.email, @required this.password});

  final String email;
  final String password;

  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}
