import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/domain/entities/item.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/feed/feed_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/user/user_bloc.dart';

import '../../../injection_container.dart';

Card buildCardUser(BuildContext context, int index, List<Item> items,
    FavouritesBloc favouritesBloc, UserBloc userBloc) {
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
      Divider(
        thickness: 2,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
                onPressed: () {
                  userBloc.add(DeleteUserItemEvent(itemId: items[index].id));
                  final feedBloc = sl<FeedBloc>();
                  feedBloc.add(RefreshFeedItemsEvent());
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                )),
          ),
          Row(
            children: [
              BlocBuilder(
                  bloc: favouritesBloc,
                  builder: (context, state) {
                    if (state is FavouritesFetchedState ||
                        state is AddedFavourite ||
                        state is RemovedFavourite) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Row(
                          children: [
                            favouritesBloc.userFavourites
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
                                    icon: Icon(Icons.favorite_outline)),
                            Text(items[index].likedBy.length.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
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
