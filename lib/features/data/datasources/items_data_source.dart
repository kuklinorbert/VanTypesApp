import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/exceptions.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/features/domain/entities/response.dart';

abstract class ItemsDataSource {
  Future<ItemsResponse> getPictures(String type, DocumentSnapshot lastDocument);
  Future<ItemsResponse> getFeedPictures(
      String type, DocumentSnapshot lastDocument);
  Future<List<Picture>> getUserItems(String userId);
  Future<List<Picture>> getUserFavourites(String userId);
}

class ItemsDataSourceImpl implements ItemsDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ItemsDataSourceImpl({@required this.firebaseFirestore});

  @override
  Future<ItemsResponse> getPictures(
      String type, DocumentSnapshot lastDocument) async {
    List<Picture> pictures = [];
    var result;
    if (lastDocument == null) {
      result = await firebaseFirestore
          .collection('pictures')
          .where("type", isEqualTo: type)
          .limit(4)
          .get();
    } else {
      result = await firebaseFirestore
          .collection('pictures')
          .where("type", isEqualTo: type)
          .startAfterDocument(lastDocument)
          .limit(4)
          .get();
    }

    result.docs.forEach((element) {
      var data = element.data();
      pictures.add(new Picture(
        id: element.id,
        link: data["link"],
        likes: int.parse(data["likesCount"].toString()),
        type: data["type"],
        uploadedBy: data["uploadedBy"],
      ));
    });

    result.docs.length < 1
        ? throw (NoMoreItemsException())
        : lastDocument = result.docs[result.docs.length - 1];

    return ItemsResponse(pictures: pictures, lastDocument: lastDocument);
  }

  @override
  Future<ItemsResponse> getFeedPictures(
      String type, DocumentSnapshot<Object> lastDocument) async {
    List<Picture> pictures = [];
    var result;
    if (lastDocument == null) {
      result = await firebaseFirestore
          .collection('pictures')
          .orderBy('likesCount', descending: true)
          .limit(4)
          .get();
    } else {
      result = await firebaseFirestore
          .collection('pictures')
          .orderBy('likesCount', descending: true)
          .limit(4)
          .startAfterDocument(lastDocument)
          .get();
    }

    result.docs.forEach((element) {
      var data = element.data();
      pictures.add(new Picture(
        id: element.id,
        link: data["link"],
        likes: int.parse(data["likesCount"].toString()),
        type: data["type"],
        uploadedBy: data["uploadedBy"],
      ));
    });

    result.docs.length < 1
        ? throw (NoMoreItemsException())
        : lastDocument = result.docs[result.docs.length - 1];

    return ItemsResponse(pictures: pictures, lastDocument: lastDocument);
  }

  @override
  Future<List<Picture>> getUserItems(String userId) async {
    List<Picture> pictures = [];
    var result = await firebaseFirestore
        .collection('pictures')
        .where('uploadedBy', isEqualTo: userId)
        .get();
    result.docs.forEach((element) {
      var data = element.data();
      pictures.add(new Picture(
        id: element.id,
        link: data["link"],
        likes: int.parse(data["likesCount"].toString()),
        type: data["type"],
        uploadedBy: data["uploadedBy"],
      ));
    });
    return pictures;
  }

  @override
  Future<List<Picture>> getUserFavourites(String userId) async {
    List<Picture> pictures = [];
    var result = await firebaseFirestore
        .collection('pictures')
        .where("likedBy", arrayContains: userId)
        .get();
    result.docs.forEach((element) {
      var data = element.data();
      pictures.add(new Picture(
        id: element.id,
        link: data["link"],
        likes: int.parse(data["likesCount"].toString()),
        type: data["type"],
        uploadedBy: data["uploadedBy"],
      ));
    });
    return pictures;
  }
}
