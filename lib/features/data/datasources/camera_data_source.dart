import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vantypesapp/features/data/models/picked_image_model.dart';

abstract class CameraDataSource {
  Future<PickedImageModel> getCameraImage();
}

class CameraDataSourceImpl implements CameraDataSource {
  final ImagePicker imagePicker;

  CameraDataSourceImpl({@required this.imagePicker});

  @override
  Future<PickedImageModel> getCameraImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    var decodedImage =
        await decodeImageFromList(File(image.path).readAsBytesSync());
    if (image != null) {
      return PickedImageModel(
          path: image.path,
          height: decodedImage.height.toDouble(),
          width: decodedImage.width.toDouble());
    } else {
      throw Exception();
    }
  }
}
