import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/data/datasources/items_data_source.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';
import 'package:vantypesapp/features/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final NetworkInfo networkInfo;
  final ItemsDataSource itemsDataSource;

  UserRepositoryImpl(
      {@required this.itemsDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, List<Item>>> getUserItems(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.getUserItems(userId);
        return Right(result);
      } on Exception {
        return Left(UserItemsFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getUserFavourites(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.getUserFavourites(userId);
        return Right(result);
      } on Exception {
        return Left(UserItemsFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteUserItem(String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.deleteUserItem(itemId);
        return Right(result);
      } on Exception {
        return Left(UserItemsFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
