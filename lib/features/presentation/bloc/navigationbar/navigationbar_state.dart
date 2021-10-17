part of 'navigationbar_bloc.dart';

abstract class NavigationbarState extends Equatable {
  const NavigationbarState();

  @override
  List<Object> get props => [];
}

class NavigationbarInitial extends NavigationbarState {}

class NavigationbarHome extends NavigationbarState {}

class NavigationbarFavourites extends NavigationbarState {}

class NavigationbarGallery extends NavigationbarState {}

class NavigationbarDetection extends NavigationbarState {}
