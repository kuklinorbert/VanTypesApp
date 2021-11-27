import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FavouritesDataSource {
  Future<List<String>> getFavourites(String uid);
  Future<String> addFavourite(String uid, String itemId);
  Future<String> removeFavourite(String uid, String itemId);
}

class FavouritesDataSourceImpl implements FavouritesDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<List<String>> getFavourites(String uid) async {
    List<String> items = [];
    var result = await firebaseFirestore
        .collection("pictures")
        .where("likedBy", arrayContains: uid)
        .get();
    result.docs.forEach((element) {
      items.add(element.id);
    });

    return items;
  }

  @override
  Future<String> addFavourite(String uid, String itemId) async {
    await firebaseFirestore.collection("pictures").doc(itemId).update({
      "likedBy": FieldValue.arrayUnion([uid]),
      "likesCount": FieldValue.increment(1)
    });

    return itemId;
  }

  @override
  Future<String> removeFavourite(String uid, String itemId) async {
    await firebaseFirestore.collection("pictures").doc(itemId).update({
      "likedBy": FieldValue.arrayRemove([uid]),
      "likesCount": FieldValue.increment(-1)
    });
    return itemId;
  }
}
