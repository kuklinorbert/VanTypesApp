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
    List<String> items;
    var result = await firebaseFirestore.collection("users").doc(uid).get();
    items = List.from(result.data()["likes"]);

    return Favourites(favourites: items);
  }

  @override
  Future<Favourites> addFavourite(String uid, String itemId) async {
    List<String> items;
    await firebaseFirestore.collection("users").doc(uid).update({
      "likes": FieldValue.arrayUnion([itemId])
    });
    var result = await firebaseFirestore.collection("users").doc(uid).get();
    items = List.from(result.data()["likes"]);

    return Favourites(favourites: items);
  }

  @override
  Future<Favourites> removeFavourite(String uid, String itemId) async {
    List<String> items;
    await firebaseFirestore.collection("users").doc(uid).update({
      "likes": FieldValue.arrayRemove([itemId])
    });
    var result = await firebaseFirestore.collection("users").doc(uid).get();
    items = List.from(result.data()["likes"]);
    return Favourites(favourites: items);
  }
}
