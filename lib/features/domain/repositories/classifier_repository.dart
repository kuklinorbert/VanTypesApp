import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vantypesapp/core/error/failure.dart';

abstract class ClassifierRepository {
  Future<Either<Failure, String>> loadModel();
  Future<Either<Failure, PermissionStatus>> checkStoragePermission();
  Future<Either<Failure, PermissionStatus>> checkCameraPermission();
  Future<Either<Failure, List>> takeImage();
  Future<Either<Failure, List>> pickGallery();
  Future<Either<Failure, List>> predict(File file);
}
