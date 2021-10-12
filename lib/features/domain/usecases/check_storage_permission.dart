import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/core/usecases/usecase.dart';
import 'package:vantypesapp/features/domain/repositories/classifier_repository.dart';

class CheckStoragePermission extends UseCase<PermissionStatus, NoParams> {
  final ClassifierRepository classifierRepository;
  CheckStoragePermission(this.classifierRepository);

  @override
  Future<Either<Failure, PermissionStatus>> call(NoParams params) async {
    return await classifierRepository.checkStoragePermission();
  }
}
