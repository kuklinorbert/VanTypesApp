import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';
import 'package:vantypesapp/features/domain/repositories/user_repository.dart';

class GetUserFavourites extends UseCase<List<Item>, Params> {
  final UserRepository userRepository;

  GetUserFavourites(this.userRepository);

  @override
  Future<Either<Failure, List<Item>>> call(params) async {
    return await userRepository.getUserFavourites(params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  Params({@required this.userId});

  @override
  List<Object> get props => [userId];
}
