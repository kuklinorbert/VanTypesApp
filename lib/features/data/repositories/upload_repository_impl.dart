import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final NetworkInfo networkInfo;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  UploadRepositoryImpl({@required this.networkInfo});

  @override
  Future<Either<Failure, String>> uploadPicture(File file, String type) async {
    if (await networkInfo.isConnected) {
      try {
        var time = DateTime.now().millisecondsSinceEpoch.toString();
        await firebaseStorage
            .ref("$type/$time.jpg")
            .putFile(file)
            .timeout(Duration(seconds: 15));
        var url = await FirebaseStorage.instance
            .ref('$type/$time.jpg')
            .getDownloadURL()
            .timeout(Duration(seconds: 15));
        await firebaseFirestore.collection('pictures').add({
          "likesCount": 0,
          "link": url,
          "type": type,
          "uploadedBy": FirebaseAuth.instance.currentUser.displayName,
          "uploadedOn": FieldValue.serverTimestamp()
        });
        return Right("success");
      } on Exception {
        return Left(UploadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
