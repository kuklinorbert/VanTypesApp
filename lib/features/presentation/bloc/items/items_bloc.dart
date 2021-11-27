import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';
import 'package:vantypesapp/features/domain/entities/items_response.dart';
import 'package:vantypesapp/features/domain/usecases/items/get_items.dart'
    as items;
import 'package:easy_localization/easy_localization.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final items.GetItems _getItems;
  List<Item> pictureList = [];
  bool isFetching = false;
  bool isError = false;
  bool isEnd = false;
  bool isReset = false;
  DocumentSnapshot lastDocument;

  ItemsBloc({@required items.GetItems getItems})
      : _getItems = getItems,
        super(ItemsInitial());

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is GetItemsEvent) {
      yield LoadingItems();
      final failureOrItems = await _getItems
          .call(items.Params(type: event.type, lastDocument: lastDocument));
      isReset = false;
      yield* _eitherLoadedOrErrorState(failureOrItems);
    }
    if (event is ResetItemsEvent) {
      yield ItemsInitial();
    }
  }

  Stream<ItemsState> _eitherLoadedOrErrorState(
    Either<Failure, ItemsResponse> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) {
        if (failure == NoMoreItemsFailure()) {
          isEnd = true;
          return LoadedItems(items: pictureList);
        } else {
          return ErrorItems(message: _mapFailureToMessage(failure));
        }
      },
      (response) {
        if (response.pictures.length < 4) {
          isEnd = true;
        }
        pictureList.addAll(response.pictures);
        lastDocument = response.lastDocument;
        return LoadedItems(items: pictureList);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return "network_fail".tr();
      case ItemsFailure:
        return "items_fail".tr();
      default:
        return 'unexp_fail'.tr();
    }
  }
}
