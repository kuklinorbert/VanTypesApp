part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class LoadingUserItems extends UserState {}

class LoadingUserFavourites extends UserState {}

class LoadedUserItems extends UserState {
  final List<Picture> items;

  LoadedUserItems({@required this.items});

  @override
  List<Object> get props => [items];
}

class LoadedFavouriteItems extends UserState {
  final List<Picture> items;

  LoadedFavouriteItems({@required this.items});

  @override
  List<Object> get props => [items];
}

class ErrorUserItems extends UserState {
  final String message;

  ErrorUserItems({@required this.message});

  @override
  List<Object> get props => [message];
}

class ErrorUserFavourites extends UserState {
  final String message;

  ErrorUserFavourites({@required this.message});

  @override
  List<Object> get props => [message];
}
