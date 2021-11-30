part of 'floating_button_bloc.dart';

abstract class FloatingButtonState extends Equatable {
  const FloatingButtonState();

  @override
  List<Object> get props => [];
}

class FloatingButtonInitial extends FloatingButtonState {}

class FloatingVisibleState extends FloatingButtonState {}

class FloatingNotVisibleState extends FloatingButtonState {}
