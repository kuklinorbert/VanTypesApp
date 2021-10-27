import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vantypesapp/features/domain/entities/favourites.dart';

abstract class FavouritesDataSource {
  Future<Favourites> getFavourites(String uid);
  Future<Favourites> addFavourite(String uid, String itemId);
  Future<Favourites> removeFavourite(String uid, String itemId);
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
      print(element.data());
      items.add(element.id);
    });

    return Favourites(favourites: items);
  }

  @override
  Future<Favourites> addFavourite(String uid, String itemId) async {
    List<String> items = [];
    await firebaseFirestore.collection("pictures").doc(itemId).update({
      "likedBy": FieldValue.arrayUnion([uid])
    });
    var result = await firebaseFirestore
        .collection("pictures")
        .where("likedBy", arrayContains: uid)
        .get();
    print(result.docs);
    result.docs.forEach((element) {
      items.add(element.id);
    });

    return Favourites(favourites: items);
  }

  @override
  Future<Favourites> removeFavourite(String uid, String itemId) async {
    List<String> items = [];
    await firebaseFirestore.collection("pictures").doc(itemId).update({
      "likedBy": FieldValue.arrayRemove([uid])
    });
    var result = await firebaseFirestore
        .collection("pictures")
        .where("likedBy", arrayContains: uid)
        .get();
    result.docs.forEach((element) {
      items.add(element.id);
    });

    return Favourites(favourites: items);
  }
}
