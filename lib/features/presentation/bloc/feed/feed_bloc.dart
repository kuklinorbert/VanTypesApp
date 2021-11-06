import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/domain/entities/response.dart';
import 'package:vantypesapp/features/domain/usecases/feed/get_feed_items.dart'
    as feed;

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  feed.GetFeedItems _getFeedItems;

  List<Picture> pictureList = [];
  bool isFetching = false;
  bool isError = false;
  bool isEnd = false;
  bool isReset = false;
  DocumentSnapshot lastDocument;

  FeedBloc({@required feed.GetFeedItems getFeedItems})
      : _getFeedItems = getFeedItems,
        super(FeedInitial());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is GetFeedItemsEvent) {
      yield LoadingFeedItems();
      final failureOrItems = await _getFeedItems
          .call(feed.Params(type: event.type, lastDocument: lastDocument));
      isReset = false;
      yield* _eitherLoadedOrErrorState(failureOrItems);
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
