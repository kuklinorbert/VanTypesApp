import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/exceptions.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/data/datasources/items_data_source.dart';
import 'package:vantypesapp/features/domain/entities/items_response.dart';
import 'package:vantypesapp/features/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final NetworkInfo networkInfo;
  final ItemsDataSource itemsDataSource;

  FeedRepositoryImpl(
      {@required this.itemsDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, ItemsResponse>> getItems(
      String type, DocumentSnapshot lastDocument) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await itemsDataSource.getFeedPictures(type, lastDocument);
        return Right(result);
      } on NoMoreItemsException {
        return Left(NoMoreItemsFailure());
      } on Exception {
        return Left(ItemsFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ItemsResponse>> refreshItems(String type) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.refreshFeedItems(type);
        return Right(result);
      } on NoMoreItemsException {
        return Left(NoMoreItemsFailure());
      } on Exception {
        return Left(ItemsFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
