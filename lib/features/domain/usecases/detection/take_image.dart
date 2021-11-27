import 'package:dartz/dartz.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/entities/picked_image.dart';
import 'package:vantypesapp/features/domain/repositories/detection_repository.dart';

class TakeImage extends UseCase<PickedImage, NoParams> {
  final ClassifierRepository classifierRepository;
  TakeImage(this.classifierRepository);
  @override
  Future<Either<Failure, PickedImage>> call(NoParams params) async {
    return await classifierRepository.takeImage();
  }
}
