import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/upload_repository.dart';

class UploadImage extends UseCase<String, Params> {
  final UploadRepository uploadRepository;

  UploadImage(this.uploadRepository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await uploadRepository.uploadPicture(params.image, params.type);
  }
}

class Params extends Equatable {
  final File image;
  final String type;

  Params({@required this.image, @required this.type});

  @override
  List<Object> get props => [image, type];
}
