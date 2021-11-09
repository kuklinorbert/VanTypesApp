import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/user/user_bloc.dart';

import '../card_user.dart';
import '../no_items.dart';

class UserItems extends StatefulWidget {
  const UserItems({
    Key key,
    @required this.userBloc,
    @required this.favouritesBloc,
    @required this.user,
  }) : super(key: key);

  final UserBloc userBloc;
  final FavouritesBloc favouritesBloc;
  final String user;

  @override
  State<UserItems> createState() => _UserItemsState();
}

class _UserItemsState extends State<UserItems>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<UserBloc, UserState>(
        bloc: widget.userBloc,
        buildWhen: (previous, current) {
          if ((previous is LoadedUserItems && current is LoadingUserItems) ||
              (previous is LoadedFavouriteItems &&
                  current is LoadingUserFavourites)) {
            return false;
          }
          if ((previous is LoadedUserItems &&
                  current is LoadingUserFavourites) ||
              (previous is LoadedFavouriteItems ||
                  current is LoadingUserItems)) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is ErrorUserFavourites || state is ErrorUserItems) {
            return IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  widget.favouritesBloc
                      .add(GetFavouritesEvent(uid: widget.user));
                  widget.userBloc.add(GetUserItemsEvent(userId: widget.user));

                  widget.userBloc
                      .add(GetUserFavouritesEvent(userId: widget.user));
                });
          } else if (state is LoadingUserItems ||
              state is LoadingUserFavourites ||
              state is UserInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedUserItems ||
              state is LoadedFavouriteItems) {
            return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return widget.userBloc.items.isEmpty
                        ? buildnoItems(context)
                        : CustomScrollView(
                            key: PageStorageKey<String>("second"),
                            slivers: [
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      buildCardUser(
                                          context,
                                          index,
                                          widget.userBloc.items,
                                          widget.favouritesBloc,
                                          widget.userBloc),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                }, childCount: widget.userBloc.items.length),
                              ),
                            ],
                          );
                  },
                ));
          }
          return Container();
        });
  }
}
