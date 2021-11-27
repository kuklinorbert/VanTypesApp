import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/exceptions.dart';
import 'package:vantypesapp/features/data/models/item_model.dart';
import 'package:vantypesapp/features/data/models/response_model.dart';

abstract class ItemsDataSource {
  Future<ItemsResponseModel> getPictures(
      String type, DocumentSnapshot lastDocument);
  Future<ItemsResponseModel> getFeedPictures(
      String type, DocumentSnapshot lastDocument);
  Future<List<ItemModel>> getUserItems(String userId);
  Future<List<ItemModel>> getUserFavourites(String userId);
  Future<String> deleteUserItem(String itemId);
  Future<ItemsResponseModel> refreshFeedItems(String type);
}

class ItemsDataSourceImpl implements ItemsDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ItemsDataSourceImpl({@required this.firebaseFirestore});

  List<ItemModel> resultToList(dynamic result) {
    List<ItemModel> pictures = [];
    result.docs.forEach((element) {
      var data = element.data();
      pictures.add(new ItemModel(
          id: element.id,
          link: data["link"],
          type: data["type"],
          uploadedBy: data["uploadedBy"],
          likedBy: data['likedBy'] != null ? List.from(data["likedBy"]) : []));
    });

    return pictures;
  }

  @override
  Future<ItemsResponseModel> getPictures(
      String type, DocumentSnapshot lastDocument) async {
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

    final pictures = resultToList(result);

    result.docs.length < 1
        ? throw (NoMoreItemsException())
        : lastDocument = result.docs[result.docs.length - 1];

    return ItemsResponseModel(pictures: pictures, lastDocument: lastDocument);
  }

  @override
  Future<ItemsResponseModel> getFeedPictures(
      String type, DocumentSnapshot<Object> lastDocument) async {
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

    final pictures = resultToList(result);

    result.docs.length < 1
        ? throw (NoMoreItemsException())
        : lastDocument = result.docs[result.docs.length - 1];

    return ItemsResponseModel(pictures: pictures, lastDocument: lastDocument);
  }

  @override
  Future<ItemsResponseModel> refreshFeedItems(String type) async {
    var result;
    if (type == "likes") {
      result = await firebaseFirestore
          .collection('pictures')
          .orderBy('likesCount', descending: true)
          .limit(4)
          .get();
    }
    if (type == "time") {
      result = await firebaseFirestore
          .collection('pictures')
          .orderBy('uploadedOn', descending: true)
          .limit(4)
          .get();
    }

    final pictures = resultToList(result);
    var lastDocument;

    result.docs.length < 1
        ? throw (NoMoreItemsException())
        : lastDocument = result.docs[result.docs.length - 1];

    return ItemsResponseModel(pictures: pictures, lastDocument: lastDocument);
  }

  @override
  Future<List<ItemModel>> getUserItems(String userId) async {
    var result = await firebaseFirestore
        .collection('pictures')
        .where('uploadedBy', isEqualTo: userId)
        .get();

    final pictures = resultToList(result);

    return pictures;
  }

  @override
  Future<List<ItemModel>> getUserFavourites(String userId) async {
    var result = await firebaseFirestore
        .collection('pictures')
        .where("likedBy", arrayContains: userId)
        .get();

    final pictures = resultToList(result);

    return pictures;
  }

  @override
  Future<String> deleteUserItem(String itemId) async {
    await firebaseFirestore.collection('pictures').doc(itemId).delete();
    return itemId;
  }
}
