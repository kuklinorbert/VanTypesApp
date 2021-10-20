import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/features/domain/entities/response.dart';
import 'package:vantypesapp/features/domain/usecases/get_items.dart' as items;
import 'package:easy_localization/easy_localization.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final items.GetItems _getItems;
  List<Picture> pictureList = [];
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
      print(isReset);
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
        return "error_network".tr();
      case ItemsFailure:
        return "error_items".tr();
      default:
        return 'error_unexp'.tr();
    }
  }
}
