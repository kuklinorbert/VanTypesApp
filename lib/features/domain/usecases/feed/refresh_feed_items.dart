import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/entities/items_response.dart';
import 'package:vantypesapp/features/domain/repositories/feed_repository.dart';

class RefreshFeedItems extends UseCase<ItemsResponse, Params> {
  final FeedRepository feedRepository;

  RefreshFeedItems(this.feedRepository);

  @override
  Future<Either<Failure, ItemsResponse>> call(Params params) async {
    return await feedRepository.refreshItems(params.type);
  }
}

class Params extends Equatable {
  final String type;

  Params({@required this.type});

  @override
  List<Object> get props => [type];
}
