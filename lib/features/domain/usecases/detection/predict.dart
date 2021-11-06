import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/detection_repository.dart';

class Predict extends UseCase<List, Params> {
  final ClassifierRepository classifierRepository;
  Predict(this.classifierRepository);
  @override
  Future<Either<Failure, List>> call(params) async {
    return await classifierRepository.predict(params.file);
  }
}

class Params extends Equatable {
  final File file;

  Params({@required this.file});

  List<Object> get props => [file];
}
