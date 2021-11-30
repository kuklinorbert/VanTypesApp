import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/domain/entities/items_response.dart';
import 'package:vantypesapp/features/domain/usecases/feed/get_feed_items.dart'
    as load;
import 'package:vantypesapp/features/domain/usecases/feed/refresh_feed_items.dart'
    as refresh;

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  load.GetFeedItems _getFeedItems;
  refresh.RefreshFeedItems _refreshFeedItemsEvent;

  List<Item> pictureList = [];
  bool isFetching = false;
  bool isError = false;
  bool isEnd = false;
  bool isReset = false;
  bool isFabVisible = true;
  String type = "likes";
  DocumentSnapshot lastDocument;

  FeedBloc(
      {@required load.GetFeedItems getFeedItems,
      @required refresh.RefreshFeedItems refreshFeedItems})
      : _getFeedItems = getFeedItems,
        _refreshFeedItemsEvent = refreshFeedItems,
        super(FeedInitial());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is GetFeedItemsEvent) {
      yield LoadingFeedItems();
      print('wonder how');
      final failureOrItems = await _getFeedItems
          .call(load.Params(type: type, lastDocument: lastDocument));
      isReset = false;
      yield* _eitherLoadedOrErrorState(failureOrItems);
    }
    if (event is RefreshFeedItemsEvent) {
      pictureList = [];
      yield LoadingFeedItems();
      final failureOrItems =
          await _refreshFeedItemsEvent.call(refresh.Params(type: type));
      isReset = false;
      yield* _eitherRefreshOrErrorState(failureOrItems);
    }
  }

  Stream<FeedState> _eitherLoadedOrErrorState(
    Either<Failure, ItemsResponse> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) {
        if (failure == NoMoreItemsFailure()) {
          isEnd = true;
          return LoadedFeedItems(items: pictureList);
        } else {
          return ErrorFeedItems(message: _mapFailureToMessage(failure));
        }
      },
      (response) {
        if (response.pictures.length < 4) {
          isEnd = true;
        }
        pictureList.addAll(response.pictures);
        lastDocument = response.lastDocument;
        return LoadedFeedItems(items: pictureList);
      },
    );
  }

  Stream<FeedState> _eitherRefreshOrErrorState(
    Either<Failure, ItemsResponse> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) {
        if (failure == NoMoreItemsFailure()) {
          isEnd = true;
          return LoadedFeedItems(items: pictureList);
        } else {
          return ErrorFeedItems(message: _mapFailureToMessage(failure));
        }
      },
      (response) {
        if (response.pictures.length < 4) {
          isEnd = true;
        }
        pictureList = response.pictures;
        lastDocument = response.lastDocument;
        return LoadedFeedItems(items: pictureList);
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
