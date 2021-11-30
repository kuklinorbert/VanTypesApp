import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vantypesapp/features/data/models/picked_image_model.dart';

abstract class DeviceDataSource {
  Future<PickedImageModel> getCameraImage();

  Future<PickedImageModel> getGalleryImage();
}

class DeviceDataSourceImpl implements DeviceDataSource {
  final ImagePicker imagePicker;

  DeviceDataSourceImpl({@required this.imagePicker});

  @override
  Future<PickedImageModel> getCameraImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      var decodedImage =
          await decodeImageFromList(File(image.path).readAsBytesSync());
      return PickedImageModel(
          path: image.path,
          height: decodedImage.height.toDouble(),
          width: decodedImage.width.toDouble());
    } else {
      throw Exception();
    }
  }

  @override
  Future<PickedImageModel> getGalleryImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var decodedImage =
          await decodeImageFromList(File(image.path).readAsBytesSync());
      return PickedImageModel(
          path: image.path,
          height: decodedImage.height.toDouble(),
          width: decodedImage.width.toDouble());
    } else {
      throw Exception();
    }
  }
}
