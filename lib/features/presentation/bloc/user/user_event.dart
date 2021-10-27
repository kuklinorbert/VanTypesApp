part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserFavouritesEvent extends UserEvent {
  final String userId;

  GetUserFavouritesEvent({@required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetUserItemsEvent extends UserEvent {
  final String userId;

  GetUserItemsEvent({@required this.userId});

  @override
  List<Object> get props => [userId];
}
