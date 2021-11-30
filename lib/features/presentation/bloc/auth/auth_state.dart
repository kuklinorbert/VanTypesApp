part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class CheckingAuthState extends AuthState {}

class LoggingInState extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class LoginErrorState extends AuthState {
  final String message;

  LoginErrorState({@required this.message});

  List<Object> get props => [message];
}
