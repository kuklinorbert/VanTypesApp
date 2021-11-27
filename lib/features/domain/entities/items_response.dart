import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';

class ItemsResponse extends Equatable {
  final List<Item> pictures;
  final DocumentSnapshot lastDocument;

  ItemsResponse({@required this.pictures, @required this.lastDocument});
  @override
  List<Object> get props => [pictures, lastDocument];
}
