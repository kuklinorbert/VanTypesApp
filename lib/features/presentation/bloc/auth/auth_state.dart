part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class CheckAuthState extends AuthState {}

class CheckingLoginState extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class ErrorLoggedState extends AuthState {
  final String message;

  ErrorLoggedState({@required this.message});

  @override
  List<Object> get props => [message];
}
