import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/features/data/models/item_model.dart';
import 'package:vantypesapp/features/domain/entities/items_response.dart';

class ItemsResponseModel extends ItemsResponse {
  final List<ItemModel> pictures;
  final DocumentSnapshot lastDocument;

  ItemsResponseModel({@required this.pictures, @required this.lastDocument});
}
