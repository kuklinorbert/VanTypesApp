import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/entities/items_response.dart';
import 'package:vantypesapp/features/domain/repositories/items_repository.dart';

class GetItems extends UseCase<ItemsResponse, Params> {
  final ItemsRepository itemsRepository;

  GetItems(this.itemsRepository);

  @override
  Future<Either<Failure, ItemsResponse>> call(Params params) async {
    return await itemsRepository.getItems(params.type, params.lastDocument);
  }
}

class Params extends Equatable {
  final String type;
  final DocumentSnapshot lastDocument;

  Params({@required this.type, @required this.lastDocument});

  @override
  List<Object> get props => [type, lastDocument];
}
