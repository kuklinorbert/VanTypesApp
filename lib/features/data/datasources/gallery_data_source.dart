import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

abstract class GalleryDataSource {
  Future<File> getCameraImage();
}

class GalleryDataSourceImpl implements GalleryDataSource {
  final ImagePicker imagePicker;

  GalleryDataSourceImpl({@required this.imagePicker});

  @override
  Future<File> getCameraImage() async {
    var image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    } else {
      throw Exception();
    }
  }
}
