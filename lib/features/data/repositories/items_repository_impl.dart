import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:vantypesapp/core/error/exceptions.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/data/datasources/items_data_source.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/features/domain/entities/response.dart';
import 'package:vantypesapp/features/domain/repositories/items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final NetworkInfo networkInfo;
  final ItemsDataSource itemsDataSource;

  ItemsRepositoryImpl(
      {@required this.itemsDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, ItemsResponse>> getItems(
      String type, DocumentSnapshot lastDocument) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.getPictures(type, lastDocument);
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
