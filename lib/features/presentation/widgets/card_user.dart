import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';

Card buildCardUser(BuildContext context, int index, List<Picture> items,
    FavouritesBloc favouritesBloc) {
  return Card(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        height: MediaQuery.of(context).size.height / 2.2,
        child: Image.network(
          items[index].link,
          fit: BoxFit.contain,
          errorBuilder: (context, child, stackTrace) {
            return Center(
              child: Text("Error loading image!"),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red,
              )),
          Row(
            children: [
              BlocBuilder(
                  bloc: favouritesBloc,
                  builder: (context, state) {
                    if (state is FavouritesFetchedState) {
                      return favouritesBloc.userFavourites
                              .contains(items[index].id)
                          ? IconButton(
                              onPressed: () {
                                favouritesBloc.add(RemoveFavouriteEvent(
                                    uid: FirebaseAuth
                                        .instance.currentUser.displayName,
                                    itemId: items[index].id));
                              },
                              icon: Icon(Icons.favorite))
                          : IconButton(
                              onPressed: () {
                                favouritesBloc.add(AddFavouriteEvent(
                                    uid: FirebaseAuth
                                        .instance.currentUser.displayName,
                                    itemId: items[index].id));
                              },
                              icon: Icon(Icons.favorite_outline));
                    } else {
                      return Container();
                    }
                  }),
              Text(items[index].likes.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            ],
          )
        ],
      ),
      SizedBox(
        height: 15,
      ),
    ],
  ));
}
