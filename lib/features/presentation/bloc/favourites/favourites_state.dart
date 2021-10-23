part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {}

class AddingFavourites extends FavouritesState {}

class RemovingFavourites extends FavouritesState {}

class FavouritesFetchedState extends FavouritesState {
  final Favourites favourites;

  FavouritesFetchedState({@required this.favourites});

  List<Object> get props => [favourites];
}
