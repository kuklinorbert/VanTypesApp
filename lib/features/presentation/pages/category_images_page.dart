import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/features/presentation/bloc/items/items_bloc.dart';

import '../../../injection_container.dart';

class CategoryImagesPage extends StatefulWidget {
  const CategoryImagesPage({Key key}) : super(key: key);

  @override
  _CategoryImagesPageState createState() => _CategoryImagesPageState();
}

class _CategoryImagesPageState extends State<CategoryImagesPage> {
  final ScrollController _scrollController = ScrollController();
  ItemsBloc itemsBloc;
  List<Picture> items = [];
  String type;

  @override
  void initState() {
    itemsBloc = sl<ItemsBloc>();
    super.initState();
  }

  @override
  void dispose() {
    itemsBloc.add(ResetItemsEvent());
    itemsBloc.close();
    sl.resetLazySingleton<ItemsBloc>(instance: sl<ItemsBloc>());
    super.dispose();
  }

  void start() {
    sl<ItemsBloc>().add(GetItemsEvent(type: type));
  }

  @override
  Widget build(BuildContext context) {
    type = ModalRoute.of(context).settings.arguments;
    return Scaffold(
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
          }

          if (state is LoadedItems) {
            itemsBloc.isFetching = false;
            itemsBloc.isError = false;
            items = state.items;
          }
        },
        builder: (context, state) {
          print(state);
          if (state is LoadingItems && items.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorItems && items.isEmpty) {
            return IconButton(
              icon: Icon(
                Icons.refresh,
                size: 35,
              ),
              onPressed: () {
                itemsBloc.add(GetItemsEvent(type: type));
              },
            );
          }
          return ListView.separated(
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
                return (!itemsBloc.isEnd && index >= items.length - 1)
                    ? (itemsBloc.isError == false)
                        ? itemsBloc.isEnd == true
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
                                  itemsBloc.isError = false;
                                  itemsBloc.add(GetItemsEvent(type: type));
                                },
                              ),
                            ),
                          )
                    : Card(
                        child: Image.network(
                          items[index].link,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: items.length);
        },
      )),
    );
  }
}
