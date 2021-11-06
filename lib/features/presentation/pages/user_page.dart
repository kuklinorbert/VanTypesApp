import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/items/items_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/user/user_bloc.dart';
import 'package:vantypesapp/features/presentation/widgets/card.dart';
import 'package:vantypesapp/features/presentation/widgets/card_user.dart';
import 'package:easy_localization/easy_localization.dart';

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
  FavouritesBloc favouritesBloc;
  String user = FirebaseAuth.instance.currentUser.displayName;

  @override
  void initState() {
    userBloc = sl<UserBloc>()..add(GetUserFavouritesEvent(userId: user));
    favouritesBloc = sl<FavouritesBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            bloc: userBloc,
            listener: (context, state) {
              if (state is LoadedUserItems) {
                userBloc.isFetching = false;
                userBloc.isError = false;
              }
              if (state is LoadedFavouriteItems) {
                userBloc.isFetching = false;
                userBloc.isError = false;
              }
              if (state is ErrorItems) {
                userBloc.isError = false;
              }
            },
          ),
          BlocListener<FavouritesBloc, FavouritesState>(
              bloc: favouritesBloc,
              listener: (context, state) {
                if (state is AddedFavourite) {
                  if (userBloc.items
                      .any((element) => element.id == state.itemId)) {
                    userBloc.items
                        .firstWhere((element) => element.id == state.itemId)
                        .likedBy
                        .add(user);
                  }
                  userBloc.add(GetUserFavouritesEvent(userId: user));
                }
                if (state is RemovedFavourite) {
                  if (userBloc.items
                      .any((element) => element.id == state.itemId)) {
                    userBloc.items
                        .firstWhere((element) => element.id == state.itemId)
                        .likedBy
                        .remove(user);
                  }
                }
                userBloc.add(GetUserFavouritesEvent(userId: user));
              })
        ],
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
                                userBloc
                                    .add(GetUserFavouritesEvent(userId: user));
                              } else {
                                userBloc.add(GetUserItemsEvent(userId: user));
                              }
                            },
                            tabs: [
                              Tab(
                                text: "my_favourites".tr(),
                              ),
                              Tab(
                                text: "my_items".tr(),
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
                                  key: PageStorageKey<String>("first"),
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
                                            buildCard(
                                                context,
                                                index,
                                                userBloc.favourites,
                                                favouritesBloc),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      },
                                          childCount:
                                              userBloc.favourites.length),
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
                                  key: PageStorageKey<String>("second"),
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
                                            buildCardUser(
                                                context,
                                                index,
                                                userBloc.items,
                                                favouritesBloc,
                                                userBloc),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      },
                                          childCount: userBloc
                                              .items.length), //items.length),
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
