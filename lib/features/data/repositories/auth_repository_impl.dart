import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({FirebaseAuth firebaseAuth, @required this.networkInfo})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Either<Failure, UserCredential>> login(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return Right(result);
      } on Exception {
        return Left(LogInFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final result = await Future.wait([_firebaseAuth.signOut()]);
      return Right(result);
    } on Exception {
      return Left(LogOutFailure());
    }
  }

  @override
  Future<Either<Failure, User>> checkAuth() async {
    try {
      final result = FirebaseAuth.instance.currentUser;
      if (result != null) {
        return Right(result);
      } else {
        return Left(CheckAuthFailure());
      }
    } on Exception {
      return Left(CheckAuthFailure());
    }
  }
}
