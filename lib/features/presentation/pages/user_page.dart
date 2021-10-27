import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/features/domain/usecases/get_user_items.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/items/items_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/user/user_bloc.dart';
import 'package:vantypesapp/features/presentation/widgets/card.dart';
import 'package:vantypesapp/features/presentation/widgets/card_user.dart';

import '../../../injection_container.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  UserBloc userBloc;
  ScrollController _scrollController = ScrollController();
  List<Picture> items = [];
  List<Picture> favourites = [];
  FavouritesBloc favouritesBloc;

  @override
  void initState() {
    userBloc = sl<UserBloc>()
      ..add(GetUserFavouritesEvent(
          userId: FirebaseAuth.instance.currentUser.displayName));
    favouritesBloc = sl<FavouritesBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<UserBloc, UserState>(
        bloc: userBloc,
        listener: (context, state) {
          if (state is LoadedUserItems) {
            userBloc.isFetching = false;
            userBloc.isError = false;
            items = state.items;
          }
          if (state is LoadedFavouriteItems) {
            userBloc.isFetching = false;
            userBloc.isError = false;
            favourites = state.items;
          }
          if (state is ErrorItems) {
            userBloc.isError = false;
          }
        },
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              controller: _scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          height: 50,
                          child: TabBar(
                            onTap: (index) {
                              if (index == 0) {
                                userBloc.add(GetUserFavouritesEvent(
                                    userId: FirebaseAuth
                                        .instance.currentUser.displayName));
                              } else {
                                userBloc.add(GetUserItemsEvent(
                                    userId: FirebaseAuth
                                        .instance.currentUser.displayName));
                              }
                            },
                            tabs: [
                              Tab(
                                text: "Favourites",
                              ),
                              Tab(
                                text: "My items",
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  )
                ];
              },
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  BlocBuilder<UserBloc, UserState>(
                      bloc: userBloc,
                      builder: (context, state) {
                        return SafeArea(
                            top: false,
                            bottom: false,
                            child: Builder(
                              builder: (BuildContext context) {
                                return CustomScrollView(
                                  key: PageStorageKey<String>("elso"),
                                  slivers: [
                                    SliverOverlapInjector(
                                      handle: NestedScrollView
                                          .sliverOverlapAbsorberHandleFor(
                                              context),
                                    ),
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            buildCard(context, index,
                                                favourites, favouritesBloc),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      }, childCount: favourites.length),
                                    ),
                                  ],
                                );
                              },
                            ));
                      }),
                  BlocBuilder<UserBloc, UserState>(
                      bloc: userBloc,
                      builder: (context, state) {
                        return SafeArea(
                            top: false,
                            bottom: false,
                            child: Builder(
                              builder: (BuildContext context) {
                                return CustomScrollView(
                                  key: PageStorageKey<String>("masodik"),
                                  slivers: [
                                    SliverOverlapInjector(
                                      handle: NestedScrollView
                                          .sliverOverlapAbsorberHandleFor(
                                              context),
                                    ),
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            buildCardUser(context, index, items,
                                                favouritesBloc),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      }, childCount: items.length),
                                    ),
                                  ],
                                );
                              },
                            ));
                      })
                ],
              )),
        ));
  }
}
