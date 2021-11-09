import 'package:flutter/cupertino.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/domain/repositories/registration_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final NetworkInfo networkInfo;
  final FirebaseFirestore _firebaseFirestore;

  RegistrationRepositoryImpl(
      {firebase_auth.FirebaseAuth firebaseAuth,
      FirebaseFirestore firebaseFirestore,
      @required this.networkInfo})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserCredential>> register(
      String userName, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        var user =
            await _firebaseFirestore.collection('users').doc(userName).get();
        if (!user.exists) {
          final result = await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password);
          await result.user.updateDisplayName(userName);
          await _firebaseFirestore
              .collection('users')
              .doc(userName)
              .set({'email': email});
          return (Right(result));
        } else {
          return (Left(RegistrationUsernameTakenFailure()));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return Left(RegistrationWeakPasswordFailure());
        } else if (e.code == 'invalid-email') {
          return Left(RegistrationInvalidEmailFailure());
        } else if (e.code == 'email-already-in-use') {
          return Left(RegistrationEmailAlreadyInUseFailure());
        }
      } on Exception {
        return Left(RegistrationFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
