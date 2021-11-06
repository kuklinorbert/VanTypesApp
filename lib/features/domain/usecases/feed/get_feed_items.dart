import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/entities/response.dart';
import 'package:vantypesapp/features/domain/repositories/feed_repository.dart';

class GetFeedItems extends UseCase<ItemsResponse, Params> {
  final FeedRepository feedRepository;

  GetFeedItems(this.feedRepository);

  @override
  Future<Either<Failure, ItemsResponse>> call(Params params) async {
    return await feedRepository.getItems(params.type, params.lastDocument);
  }
}

class Params extends Equatable {
  final String type;
  final DocumentSnapshot lastDocument;

  Params({@required this.type, @required this.lastDocument});

  @override
  List<Object> get props => [type, lastDocument];
}
