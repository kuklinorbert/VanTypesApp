import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/favourites.dart';

abstract class FavouritesRepository {
  Future<Either<Failure, Favourites>> getFavourites(String uid);
  Future<Either<Failure, String>> addFavourite(String uid, String itemId);
  Future<Either<Failure, String>> removeFavourite(String uid, String itemId);
}
