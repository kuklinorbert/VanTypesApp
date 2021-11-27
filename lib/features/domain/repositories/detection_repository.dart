import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/picked_image.dart';

abstract class ClassifierRepository {
  Future<Either<Failure, String>> loadModel();
  Future<Either<Failure, PermissionStatus>> checkStoragePermission();
  Future<Either<Failure, PermissionStatus>> checkCameraPermission();
  Future<Either<Failure, PickedImage>> takeImage();
  Future<Either<Failure, PickedImage>> pickGallery();
  Future<Either<Failure, List>> predict(String file);
}
