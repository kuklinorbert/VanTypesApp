import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/features/domain/repositories/user_repository.dart';

class GetUserItems extends UseCase<List<Picture>, Params> {
  final UserRepository userRepository;

  GetUserItems(this.userRepository);

  @override
  Future<Either<Failure, List<Picture>>> call(Params params) async {
    return await userRepository.getUserItems(params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  Params({@required this.userId});

  @override
  List<Object> get props => [userId];
}
