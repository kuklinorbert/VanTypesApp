import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Picture extends Equatable {
  Picture(
      {@required this.id,
      @required this.link,
      @required this.uploadedBy,
      @required this.type,
      @required this.likes});

  final String id;
  final String link;
  final String uploadedBy;
  final String type;
  final int likes;

  @override
  List<Object> get props => [id, link, uploadedBy, type, likes];
}
