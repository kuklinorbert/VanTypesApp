import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PickedImage extends Equatable {
  final String path;
  final double width;
  final double height;

  PickedImage({@required this.path, this.width, this.height});

  @override
  List<Object> get props => [path, width, height];
}
