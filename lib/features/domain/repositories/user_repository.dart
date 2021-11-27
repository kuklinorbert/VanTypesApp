import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';

abstract class UserRepository {
  Future<Either<Failure, List<Item>>> getUserItems(String userId);
  Future<Either<Failure, List<Item>>> getUserFavourites(String userId);
  Future<Either<Failure, String>> deleteUserItem(String itemId);
}
