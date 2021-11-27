import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Item extends Equatable {
  Item(
      {@required this.id,
      @required this.link,
      @required this.uploadedBy,
      @required this.type,
      @required this.likedBy});

  final String id;
  final String link;
  final String uploadedBy;
  final String type;
  final List<String> likedBy;

  @override
  List<Object> get props => [id, link, uploadedBy, type, likedBy];
}
