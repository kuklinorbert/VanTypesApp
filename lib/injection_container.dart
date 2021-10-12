import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vantypesapp/features/data/datasources/camera_data_source.dart';
import 'package:vantypesapp/features/data/datasources/gallery_data_source.dart';
import 'package:vantypesapp/features/data/repositories/classifier_repository_impl.dart';
import 'package:vantypesapp/features/domain/repositories/classifier_repository.dart';
import 'package:vantypesapp/features/domain/usecases/check_camera_permission.dart';
import 'package:vantypesapp/features/domain/usecases/check_storage_permission.dart';
import 'package:vantypesapp/features/domain/usecases/load_model.dart';
import 'package:vantypesapp/features/domain/usecases/pick_gallery.dart';
import 'package:vantypesapp/features/domain/usecases/predict.dart';
import 'package:vantypesapp/features/domain/usecases/take_image.dart';
import 'package:vantypesapp/features/presentation/bloc/classification/classification_bloc.dart';

import 'core/util/image_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => ClassificationBloc(
      checkCameraPermission: sl(),
      checkStoragePermission: sl(),
      loadModel: sl(),
      pickGallery: sl(),
      predict: sl(),
      takeImage: sl()));

  sl.registerLazySingleton(() => CheckCameraPermission(sl()));
  sl.registerLazySingleton(() => CheckStoragePermission(sl()));
  sl.registerLazySingleton(() => LoadModel(sl()));
  sl.registerLazySingleton(() => PickGallery(sl()));
  sl.registerLazySingleton(() => Predict(sl()));
  sl.registerLazySingleton(() => TakeImage(sl()));

  sl.registerLazySingleton<ClassifierRepository>(() => ClassifierRepositoryImpl(
      galleryDataSource: sl(), cameraDataSource: sl(), imageConverter: sl()));

  sl.registerLazySingleton<CameraDataSource>(
      () => CameraDataSourceImpl(imagePicker: sl()));
  sl.registerLazySingleton<GalleryDataSource>(
      () => GalleryDataSourceImpl(imagePicker: sl()));

  sl.registerLazySingleton(() => ImageConverter());
  sl.registerLazySingleton(() => ImagePicker());
}
