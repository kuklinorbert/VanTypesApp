import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/feed/feed_bloc.dart';
import 'package:vantypesapp/features/presentation/widgets/card.dart';

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
  String type = "all";
  final user = FirebaseAuth.instance.currentUser.displayName;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    feedBloc = sl<FeedBloc>();
    favouritesBloc = sl<FavouritesBloc>()
      ..add(GetFavouritesEvent(
          uid: FirebaseAuth.instance.currentUser.displayName));
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
    return BlocListener<FavouritesBloc, FavouritesState>(
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
        bloc: feedBloc..add(GetFeedItemsEvent(type: type)),
        listener: (context, state) {
          if (state is ErrorFeedItems) {
            feedBloc.isError = true;
          }

          if (state is LoadedFeedItems) {
            feedBloc.isFetching = false;
            feedBloc.isError = false;
          }
        },
        builder: (context, state) {
          if (state is LoadingFeedItems && feedBloc.pictureList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorFeedItems && feedBloc.pictureList.isEmpty) {
            return IconButton(
              icon: Icon(
                Icons.refresh,
                size: 35,
              ),
              onPressed: () {
                feedBloc.add(GetFeedItemsEvent(type: type));
              },
            );
          }
          return ListView.separated(
              controller: _scrollController
                ..addListener(() {
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      !feedBloc.isFetching &&
                      !feedBloc.isEnd) {
                    feedBloc.add(GetFeedItemsEvent(type: type));
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
                                padding: const EdgeInsets.only(bottom: 15),
                                child: CircularProgressIndicator(),
                              ))
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: IconButton(
                                icon: Icon(
                                  Icons.refresh,
                                  size: 35,
                                ),
                                onPressed: () {
                                  feedBloc.isError = false;
                                  feedBloc.add(GetFeedItemsEvent(type: type));
                                },
                              ),
                            ),
                          )
                    : buildCard(
                        context, index, feedBloc.pictureList, favouritesBloc);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: feedBloc.pictureList.length);
        },
      )),
    );
  }
}
