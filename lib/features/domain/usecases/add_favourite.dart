import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/entities/favourites.dart';
import 'package:vantypesapp/features/domain/repositories/favourites_repository.dart';

class AddFavourite extends UseCase<Favourites, Params> {
  final FavouritesRepository favouritesRepository;

  AddFavourite(this.favouritesRepository);
  @override
  Future<Either<Failure, Favourites>> call(Params params) async {
    return await favouritesRepository.addFavourite(params.uid, params.itemId);
  }
}

class Params extends Equatable {
  final String uid;
  final String itemId;

  Params({@required this.uid, @required this.itemId});

  List<Object> get props => [uid, itemId];
}
