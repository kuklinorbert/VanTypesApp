import 'package:vantypesapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/detection_repository.dart';

class LoadModel extends UseCase<String, NoParams> {
  final ClassifierRepository classifierRepository;
  LoadModel(this.classifierRepository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await classifierRepository.loadModel();
  }
}
