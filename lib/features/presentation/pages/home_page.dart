import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/feed/feed_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/floating_button_bloc/floating_button_bloc.dart';
import 'package:vantypesapp/features/presentation/widgets/card.dart';
import 'package:vantypesapp/features/presentation/widgets/no_items.dart';
import 'package:vantypesapp/features/presentation/widgets/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../injection_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  FeedBloc feedBloc;
  FavouritesBloc favouritesBloc;
  FloatingButtonBloc floatingButtonBloc;
  bool isFabVisible = true;
  final user = FirebaseAuth.instance.currentUser.displayName;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    feedBloc = sl<FeedBloc>();
    favouritesBloc = sl<FavouritesBloc>()
      ..add(GetFavouritesEvent(
          uid: FirebaseAuth.instance.currentUser.displayName));
    floatingButtonBloc = sl<FloatingButtonBloc>();
    super.initState();
  }

  @override
  void dispose() {
    feedBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<FloatingButtonBloc, FloatingButtonState>(
        bloc: floatingButtonBloc,
        builder: (context, state) {
          if (state is FloatingVisibleState) {
            return AnimatedOpacity(
                opacity: floatingButtonBloc.isVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 1000),
                child: FloatingActionButton(
                    child: Icon(Icons.sort),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 15, top: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "sort_by".tr(),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.favorite),
                                  title: Text(
                                    "by_likes".tr(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    feedBloc.add(RefreshFeedItemsEvent());
                                    feedBloc.type = "likes";
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.date_range),
                                  title: Text(
                                    "by_date".tr(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    feedBloc.add(RefreshFeedItemsEvent());
                                    feedBloc.type = "time";
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    }));
          } else {
            return Container();
          }
        },
      ),
      body: BlocListener<FavouritesBloc, FavouritesState>(
        bloc: favouritesBloc,
        listener: (context, state) {
          if (state is AddedFavourite) {
            if (feedBloc.pictureList
                .any((element) => element.id == state.itemId)) {
              feedBloc.pictureList
                  .firstWhere((element) => element.id == state.itemId)
                  .likedBy
                  .add(user);
            }
          }
          if (state is RemovedFavourite) {
            if (feedBloc.pictureList
                .any((element) => element.id == state.itemId)) {
              feedBloc.pictureList
                  .firstWhere((element) => element.id == state.itemId)
                  .likedBy
                  .remove(user);
            }
          }
        },
        child: Container(
            child: BlocConsumer<FeedBloc, FeedState>(
          bloc: feedBloc..add(GetFeedItemsEvent()),
          listener: (context, state) {
            if (state is ErrorFeedItems) {
              feedBloc.isError = true;
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackBar(context, state.message));
            }

            if (state is LoadedFeedItems) {
              feedBloc.isFetching = false;
              feedBloc.isError = false;
            }
          },
          buildWhen: (previous, current) {
            if (previous is LoadedFeedItems && current is LoadedFeedItems) {
              return false;
            } else {
              return true;
            }
          },
          builder: (context, state) {
            if (state is LoadingFeedItems && feedBloc.pictureList.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ErrorFeedItems &&
                feedBloc.pictureList.isEmpty) {
              return Center(
                child: IconButton(
                  iconSize: 40,
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    favouritesBloc.add(GetFavouritesEvent(uid: user));
                    feedBloc.add(RefreshFeedItemsEvent());
                  },
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                feedBloc.add(RefreshFeedItemsEvent());
              },
              child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.direction == ScrollDirection.forward) {
                    // if (!isFabVisible)
                    //   // setState(() {
                    //   //   isFabVisible = true;
                    //   // });
                    floatingButtonBloc.add(FloatingVisible());
                  } else if (notification.direction ==
                      ScrollDirection.reverse) {
                    //if (isFabVisible)
                    // setState(() {
                    //   isFabVisible = false;
                    // });
                    floatingButtonBloc.add(FloatingNotVisible());
                  }
                  return true;
                },
                child: feedBloc.pictureList.isEmpty
                    ? buildnoItems(context)
                    : ListView.separated(
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset ==
                                    _scrollController
                                        .position.maxScrollExtent &&
                                !feedBloc.isFetching &&
                                !feedBloc.isEnd) {
                              feedBloc.add(GetFeedItemsEvent());
                              feedBloc.isFetching = true;
                            }
                          }),
                        itemBuilder: (context, index) {
                          return (!feedBloc.isEnd &&
                                  index >= feedBloc.pictureList.length - 1)
                              ? (feedBloc.isError == false)
                                  ? feedBloc.isEnd == true
                                      ? Container()
                                      : Center(
                                          child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: CircularProgressIndicator(),
                                        ))
                                  : Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.refresh,
                                            size: 35,
                                          ),
                                          onPressed: () {
                                            feedBloc.isError = false;
                                            feedBloc.add(GetFeedItemsEvent());
                                          },
                                        ),
                                      ),
                                    )
                              : buildCard(context, index, feedBloc.pictureList,
                                  favouritesBloc);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: feedBloc.pictureList.length),
              ),
            );
          },
        )),
      ),
    );
  }
}
