import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vantypesapp/features/domain/entities/favourites.dart';

abstract class FavouritesDataSource {
  Future<Favourites> getFavourites(String uid);
  Future<String> addFavourite(String uid, String itemId);
  Future<String> removeFavourite(String uid, String itemId);
}

class FavouritesDataSourceImpl implements FavouritesDataSource {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<Favourites> getFavourites(String uid) async {
    List<String> items = [];
    var result = await firebaseFirestore
        .collection("pictures")
        .where("likedBy", arrayContains: uid)
        .get();
    result.docs.forEach((element) {
      items.add(element.id);
    });

    return Favourites(favourites: items);
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
