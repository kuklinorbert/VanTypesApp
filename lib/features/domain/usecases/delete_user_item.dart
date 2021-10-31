import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/user_repository.dart';

class DeleteUserItem extends UseCase<String, Params> {
  final UserRepository userRepository;

  DeleteUserItem(this.userRepository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await userRepository.deleteUserItem(params.itemId);
  }
}

class Params extends Equatable {
  final String itemId;

  Params({@required this.itemId});

  @override
  List<Object> get props => [itemId];
}
