import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/detection_repository.dart';

class TakeImage extends UseCase<List, NoParams> {
  final ClassifierRepository classifierRepository;
  TakeImage(this.classifierRepository);
  @override
  Future<Either<Failure, List>> call(NoParams params) async {
    return await classifierRepository.takeImage();
  }
}
