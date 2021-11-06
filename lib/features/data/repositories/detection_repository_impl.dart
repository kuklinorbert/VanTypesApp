import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/util/image_converter.dart';
import 'package:vantypesapp/features/data/datasources/camera_data_source.dart';
import 'package:vantypesapp/features/data/datasources/gallery_data_source.dart';
import 'dart:io';

import 'package:vantypesapp/features/domain/repositories/detection_repository.dart';

class ClassifierRepositoryImpl implements ClassifierRepository {
  final GalleryDataSource galleryDataSource;
  final CameraDataSource cameraDataSource;
  final ImageConverter imageConverter;

  ClassifierRepositoryImpl(
      {@required this.galleryDataSource,
      @required this.cameraDataSource,
      @required this.imageConverter});

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
  Future<Either<Failure, List>> pickGallery() async {
    try {
      final image = await galleryDataSource.getCameraImage();
      var decodedImage = await decodeImageFromList(image.readAsBytesSync());
      return Right([
        image.path,
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble()
      ]);
    } on Exception {
      return Left(ImageFailure());
    }
  }

  @override
  Future<Either<Failure, List>> predict(File image) async {
    try {
      var output = await Tflite.detectObjectOnImage(
          path: image.path, threshold: 0.7, numResultsPerClass: 1);
      return Right(output);
    } on Exception {
      return Left(PredictionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> takeImage() async {
    try {
      final image = await cameraDataSource.getCameraImage();
      var decodedImage = await decodeImageFromList(image.readAsBytesSync());
      return Right([
        image.path,
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble()
      ]);
    } on Exception {
      return Left(ImageFailure());
    }
  }
}
