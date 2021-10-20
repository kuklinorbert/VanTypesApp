import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vantypesapp/core/error/failure.dart';

abstract class RegistrationRepository {
  Future<Either<Failure, UserCredential>> register(
      String userName, String email, String password);
}
