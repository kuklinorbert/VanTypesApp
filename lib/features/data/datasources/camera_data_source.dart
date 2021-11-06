import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

abstract class CameraDataSource {
  Future<File> getCameraImage();
}

class CameraDataSourceImpl implements CameraDataSource {
  final ImagePicker imagePicker;

  CameraDataSourceImpl({@required this.imagePicker});

  @override
  Future<File> getCameraImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    } else {
      throw Exception();
    }
  }
}
