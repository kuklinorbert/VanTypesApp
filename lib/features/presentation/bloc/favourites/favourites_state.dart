part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {}

class AddedFavourite extends FavouritesState {
  final String itemId;

  AddedFavourite({@required this.itemId});

  List<Object> get props => [itemId];
}

class RemovedFavourite extends FavouritesState {
  final String itemId;

  RemovedFavourite({@required this.itemId});

  List<Object> get props => [itemId];
}

class FavouritesFetchedState extends FavouritesState {
  final List<String> favourites;

  FavouritesFetchedState({@required this.favourites});

  List<Object> get props => [favourites];
}

class FavouritesErrorState extends FavouritesState {
  final String message;

  FavouritesErrorState({@required this.message});

  List<Object> get props => [message];
}
