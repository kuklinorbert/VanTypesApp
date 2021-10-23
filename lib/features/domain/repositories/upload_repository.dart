import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';

abstract class UploadRepository {
  Future<Either<Failure, String>> uploadPicture(File image, String type);
}
