import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/user/user_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/presentation/widgets/snackbar.dart';
import 'package:vantypesapp/features/presentation/widgets/user/user_favourites.dart';
import 'package:vantypesapp/features/presentation/widgets/user/user_items.dart';

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
              print(state);
              if (state is ErrorUserItems) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(buildSnackBar(context, state.message));
              }
              if (state is ErrorUserFavourites) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(buildSnackBar(context, state.message));
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
                  userBloc.add(GetUserFavouritesEvent(userId: user));
                }
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
                  UserFavourites(
                      userBloc: userBloc,
                      favouritesBloc: favouritesBloc,
                      user: user),
                  UserItems(
                      userBloc: userBloc,
                      favouritesBloc: favouritesBloc,
                      user: user)
                ],
              )),
        ));
  }
}
