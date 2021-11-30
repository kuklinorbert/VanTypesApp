import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/features/data/datasources/device_data_source.dart';
import 'package:vantypesapp/features/domain/entities/picked_image.dart';

import 'package:vantypesapp/features/domain/repositories/detection_repository.dart';

class ClassifierRepositoryImpl implements ClassifierRepository {
  final DeviceDataSource deviceDataSource;

  ClassifierRepositoryImpl({@required this.deviceDataSource});

  @override
  Future<Either<Failure, PermissionStatus>> checkStoragePermission() async {
    final permission = await Permission.storage.request();
    if (permission.isGranted) {
      return Right(permission);
    } else {
      return Left(PermissionFailure());
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> checkCameraPermission() async {
    final permission = await Permission.camera.request();
    if (permission.isGranted) {
      return Right(permission);
    } else {
      return Left(PermissionFailure());
    }
  }

  @override
  Future<Either<Failure, String>> loadModel() async {
    try {
      String result = await Tflite.loadModel(
          model: "assets/model/model.tflite",
          labels: 'assets/model/labels.txt');
      return Right(result);
    } on Exception {
      return Left(LoadModelFailure());
    }
  }

  @override
  Future<Either<Failure, PickedImage>> pickGallery() async {
    try {
      final image = await deviceDataSource.getGalleryImage();
      return Right(image);
    } on Exception {
      return Left(ImageFailure());
    }
  }

  @override
  Future<Either<Failure, List>> predict(String image) async {
    try {
      var output = await Tflite.detectObjectOnImage(
          path: image, threshold: 0.7, numResultsPerClass: 1);
      return Right(output);
    } on Exception {
      return Left(PredictionFailure());
    }
  }

  @override
  Future<Either<Failure, PickedImage>> takeImage() async {
    try {
      final image = await deviceDataSource.getCameraImage();
      return Right(image);
    } on Exception {
      return Left(ImageFailure());
    }
  }
}
