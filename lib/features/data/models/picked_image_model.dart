import 'package:flutter/material.dart';
import 'package:vantypesapp/features/domain/entities/picked_image.dart';

class PickedImageModel extends PickedImage {
  PickedImageModel(
      {@required this.path, @required this.width, @required this.height});

  final String path;
  final double width;
  final double height;
}
