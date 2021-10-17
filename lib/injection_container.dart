import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vantypesapp/core/util/network_info.dart';
import 'package:vantypesapp/features/data/datasources/camera_data_source.dart';
import 'package:vantypesapp/features/data/datasources/gallery_data_source.dart';
import 'package:vantypesapp/features/data/repositories/auth_repository_impl.dart';
import 'package:vantypesapp/features/data/repositories/detection_repository_impl.dart';
import 'package:vantypesapp/features/domain/repositories/auth_repository.dart';
import 'package:vantypesapp/features/domain/repositories/detection_repository.dart';
import 'package:vantypesapp/features/domain/usecases/check_camera_permission.dart';
import 'package:vantypesapp/features/domain/usecases/check_storage_permission.dart';
import 'package:vantypesapp/features/domain/usecases/load_model.dart';
import 'package:vantypesapp/features/domain/usecases/pick_gallery.dart';
import 'package:vantypesapp/features/domain/usecases/predict.dart';
import 'package:vantypesapp/features/domain/usecases/take_image.dart';
import 'package:vantypesapp/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/detection/detection_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/navigationbar/navigationbar_bloc.dart';

import 'core/util/image_converter.dart';
import 'features/domain/usecases/check_auth.dart';
import 'features/domain/usecases/login.dart';
import 'features/domain/usecases/logout.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => DetectionBloc(
      checkCameraPermission: sl(),
      checkStoragePermission: sl(),
      loadModel: sl(),
      pickGallery: sl(),
      predict: sl(),
      takeImage: sl()));

  sl.registerLazySingleton(
      () => AuthBloc(login: sl(), logout: sl(), checkAuth: sl()));

  sl.registerLazySingleton(() => NavigationbarBloc());

  sl.registerLazySingleton(() => CheckCameraPermission(sl()));
  sl.registerLazySingleton(() => CheckStoragePermission(sl()));
  sl.registerLazySingleton(() => LoadModel(sl()));
  sl.registerLazySingleton(() => PickGallery(sl()));
  sl.registerLazySingleton(() => Predict(sl()));
  sl.registerLazySingleton(() => TakeImage(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => CheckAuth(sl()));

  sl.registerLazySingleton<ClassifierRepository>(() => ClassifierRepositoryImpl(
      galleryDataSource: sl(), cameraDataSource: sl(), imageConverter: sl()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(firebaseAuth: sl(), networkInfo: sl()));

  sl.registerLazySingleton<CameraDataSource>(
      () => CameraDataSourceImpl(imagePicker: sl()));
  sl.registerLazySingleton<GalleryDataSource>(
      () => GalleryDataSourceImpl(imagePicker: sl()));

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl(),
    ),
  );

  sl.registerLazySingleton(() => ImageConverter());
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
