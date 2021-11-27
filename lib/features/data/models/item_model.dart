import 'package:flutter/material.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel(
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
}
