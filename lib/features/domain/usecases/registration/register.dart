import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/registration_repository.dart';

class Register implements UseCase<UserCredential, Params> {
  final RegistrationRepository registrationRepository;

  Register(this.registrationRepository);

  @override
  Future<Either<Failure, UserCredential>> call(params) async {
    return await registrationRepository.register(
        params.userName, params.email, params.password);
  }
}

class Params extends Equatable {
  final String userName;
  final String email;
  final String password;

  Params(
      {@required this.userName, @required this.email, @required this.password});

  @override
  List<Object> get props => [userName, email, password];
}
