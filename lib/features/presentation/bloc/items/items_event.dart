part of 'items_bloc.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class GetItemsEvent extends ItemsEvent {
  final String type;

  GetItemsEvent({@required this.type});

  @override
  List<Object> get props => [type];
}

class ResetItemsEvent extends ItemsEvent {}
