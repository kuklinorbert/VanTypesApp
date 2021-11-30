part of 'floating_button_bloc.dart';

abstract class FloatingButtonEvent extends Equatable {
  const FloatingButtonEvent();

  @override
  List<Object> get props => [];
}

class FloatingVisible extends FloatingButtonEvent {}

class FloatingNotVisible extends FloatingButtonEvent {}
