import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';

abstract class FavouritesRepository {
  Future<Either<Failure, List<String>>> getFavourites(String uid);
  Future<Either<Failure, String>> addFavourite(String uid, String itemId);
  Future<Either<Failure, String>> removeFavourite(String uid, String itemId);
}
