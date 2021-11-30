import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/items/items_bloc.dart';
import 'package:vantypesapp/features/presentation/widgets/card.dart';
import 'package:vantypesapp/features/presentation/widgets/no_items.dart';
import 'package:vantypesapp/features/presentation/widgets/snackbar.dart';

import '../../../injection_container.dart';

class CategoryImagesPage extends StatefulWidget {
  const CategoryImagesPage({Key key}) : super(key: key);

  @override
  _CategoryImagesPageState createState() => _CategoryImagesPageState();
}

class _CategoryImagesPageState extends State<CategoryImagesPage> {
  final ScrollController _scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser.displayName;
  ItemsBloc itemsBloc;
  FavouritesBloc favouritesBloc;
  String type;

  @override
  void initState() {
    itemsBloc = sl<ItemsBloc>();
    favouritesBloc = sl<FavouritesBloc>();
    super.initState();
  }

  @override
  void dispose() {
    itemsBloc.add(ResetItemsEvent());
    itemsBloc.close();
    sl.resetLazySingleton<ItemsBloc>(instance: sl<ItemsBloc>());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void start() {
    sl<ItemsBloc>().add(GetItemsEvent(type: type));
  }

  @override
  Widget build(BuildContext context) {
    type = ModalRoute.of(context).settings.arguments;
    return BlocListener<FavouritesBloc, FavouritesState>(
        bloc: favouritesBloc,
        listener: (context, state) {
          if (state is AddedFavourite) {
            itemsBloc.pictureList
                .firstWhere((element) => element.id == state.itemId)
                .likedBy
                .add(user);
          }
          if (state is RemovedFavourite) {
            itemsBloc.pictureList
                .firstWhere((element) => element.id == state.itemId)
                .likedBy
                .remove(user);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.purple,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
              child: BlocConsumer<ItemsBloc, ItemsState>(
            bloc: itemsBloc..add(GetItemsEvent(type: type)),
            listener: (context, state) {
              if (state is ErrorItems) {
                itemsBloc.isError = true;
                ScaffoldMessenger.of(context)
                    .showSnackBar(buildSnackBar(context, state.message));
              }

              if (state is LoadedItems) {
                itemsBloc.isFetching = false;
                itemsBloc.isError = false;
              }
            },
            builder: (context, state) {
              if (state is LoadingItems && itemsBloc.pictureList.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ErrorItems && itemsBloc.pictureList.isEmpty) {
                return Center(
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.refresh,
                    ),
                    onPressed: () {
                      favouritesBloc.add(GetFavouritesEvent(uid: user));
                      itemsBloc..add(GetItemsEvent(type: type));
                    },
                  ),
                );
              }
              return itemsBloc.pictureList.isEmpty
                  ? buildnoItems(context)
                  : ListView.separated(
                      controller: _scrollController
                        ..addListener(() {
                          if (_scrollController.offset ==
                                  _scrollController.position.maxScrollExtent &&
                              !itemsBloc.isFetching &&
                              !itemsBloc.isEnd) {
                            itemsBloc.add(GetItemsEvent(type: type));
                            itemsBloc.isFetching = true;
                          }
                        }),
                      itemBuilder: (context, index) {
                        return (!itemsBloc.isEnd &&
                                index >= itemsBloc.pictureList.length - 1)
                            ? (itemsBloc.isError == false)
                                ? itemsBloc.isEnd == true
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
                                          itemsBloc.isError = false;
                                          itemsBloc
                                              .add(GetItemsEvent(type: type));
                                        },
                                      ),
                                    ),
                                  )
                            : buildCard(context, index, itemsBloc.pictureList,
                                favouritesBloc);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: itemsBloc.pictureList.length);
            },
          )),
        ));
  }
}
