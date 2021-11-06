import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/favourites_repository.dart';

class RemoveFavourite extends UseCase<String, Params> {
  final FavouritesRepository favouritesRepository;

  RemoveFavourite(this.favouritesRepository);
  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await favouritesRepository.removeFavourite(
        params.uid, params.itemId);
  }
}

class Params extends Equatable {
  final String uid;
  final String itemId;

  Params({@required this.uid, @required this.itemId});

  List<Object> get props => [uid, itemId];
}
