import 'package:flutter/material.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/data/datasources/favourites_data_source.dart';
import 'package:vantypesapp/features/domain/entities/favourites.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/features/domain/repositories/favourites_repository.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final NetworkInfo networkInfo;
  final FavouritesDataSource favouritesDataSource;

  FavouritesRepositoryImpl(
      {@required this.favouritesDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, String>> addFavourite(
      String uid, String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await favouritesDataSource.addFavourite(uid, itemId);
        return Right(result);
      } on Exception {
        return Left(FavouritesFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Favourites>> getFavourites(String uid) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await favouritesDataSource.getFavourites(uid);
        return Right(result);
      } on Exception {
        return Left(FavouritesFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> removeFavourite(
      String uid, String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await favouritesDataSource.removeFavourite(uid, itemId);
        return Right(result);
      } on Exception {
        return Left(FavouritesFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
