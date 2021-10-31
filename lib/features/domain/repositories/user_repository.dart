import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';

abstract class UserRepository {
  Future<Either<Failure, List<Picture>>> getUserItems(String userId);
  Future<Either<Failure, List<Picture>>> getUserFavourites(String userId);
  Future<Either<Failure, String>> deleteUserItem(String itemId);
}
