part of 'navigationbar_bloc.dart';

abstract class NavigationbarEvent extends Equatable {
  const NavigationbarEvent();

  @override
  List<Object> get props => [];
}

class HomeSelected extends NavigationbarEvent {}

class FavouritesSelected extends NavigationbarEvent {}

class GallerySelected extends NavigationbarEvent {}

class DetectionSelected extends NavigationbarEvent {}
