import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/items_response.dart';

abstract class ItemsRepository {
  Future<Either<Failure, ItemsResponse>> getItems(
      String type, DocumentSnapshot lastDocument);
}
