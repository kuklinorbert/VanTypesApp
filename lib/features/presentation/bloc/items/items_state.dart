part of 'items_bloc.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsInitial extends ItemsState {}

class LoadingItems extends ItemsState {}

class LoadedItems extends ItemsState {
  final List<Picture> items;

  LoadedItems({@required this.items});

  @override
  List<Object> get props => [items];
}

class ErrorItems extends ItemsState {
  final String message;

  ErrorItems({@required this.message});

  @override
  List<Object> get props => [message];
}
