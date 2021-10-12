import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/classifier_repository.dart';

class PickGallery extends UseCase<List, NoParams> {
  final ClassifierRepository classifierRepository;
  PickGallery(this.classifierRepository);
  @override
  Future<Either<Failure, List>> call(NoParams params) async {
    return await classifierRepository.pickGallery();
  }
}
