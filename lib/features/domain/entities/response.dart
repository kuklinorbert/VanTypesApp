import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';

class ItemsResponse extends Equatable {
  final List<Picture> pictures;
  final DocumentSnapshot lastDocument;

  ItemsResponse({@required this.pictures, @required this.lastDocument});
  @override
  List<Object> get props => [pictures, lastDocument];
}
