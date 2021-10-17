import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vantypesapp/core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserCredential>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> checkAuth();
}
