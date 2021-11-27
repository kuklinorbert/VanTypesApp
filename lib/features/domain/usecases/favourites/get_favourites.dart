import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/favourites_repository.dart';

class GetFavourites extends UseCase<List<String>, Params> {
  final FavouritesRepository favouritesRepository;

  GetFavourites(this.favouritesRepository);

  @override
  Future<Either<Failure, List<String>>> call(Params params) async {
    return await favouritesRepository.getFavourites(params.uid);
  }
}

class Params extends Equatable {
  final String uid;
  Params({@required this.uid});

  @override
  List<Object> get props => [uid];
}
