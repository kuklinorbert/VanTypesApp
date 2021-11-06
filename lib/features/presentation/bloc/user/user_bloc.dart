import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';
import 'package:vantypesapp/features/domain/usecases/user/delete_user_item.dart'
    as delete;
import 'package:vantypesapp/features/domain/usecases/user/get_user_favourites.dart'
    as userFav;
import 'package:vantypesapp/features/domain/usecases/user/get_user_items.dart'
    as userItems;
import 'package:easy_localization/easy_localization.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final userItems.GetUserItems _getUserItems;
  final userFav.GetUserFavourites _getUserFavourites;
  final delete.DeleteUserItem _deleteUserItem;
  List<Picture> items = [];
  List<Picture> favourites = [];
  bool isFetching = false;
  bool isError = false;
  bool isEnd = false;
  bool isReset = false;

  UserBloc(
      {@required userItems.GetUserItems getUserItems,
      @required userFav.GetUserFavourites getUserFavourites,
      @required delete.DeleteUserItem deleteUserItem})
      : _getUserItems = getUserItems,
        _getUserFavourites = getUserFavourites,
        _deleteUserItem = deleteUserItem,
        super(UserInitial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetUserItemsEvent) {
      yield LoadingUserItems();
      final failureOrItems =
          await _getUserItems.call(userItems.Params(userId: event.userId));
      yield* _eitherUserItemsOrErrorState(failureOrItems);
    }
    if (event is GetUserFavouritesEvent) {
      yield LoadingUserItems();
      final failureOrFavourites =
          await _getUserFavourites(userFav.Params(userId: event.userId));
      yield* _eitherUserFavouritesOrErrorState(failureOrFavourites);
    }
    if (event is DeleteUserItemEvent) {
      yield LoadingUserItems();
      final failureOrDelete =
          await _deleteUserItem(delete.Params(itemId: event.itemId));
      yield* _eitherUserItemDeleteOrErrorState(failureOrDelete);
    }
  }

  Stream<UserState> _eitherUserItemsOrErrorState(
    Either<Failure, List<Picture>> failureOrItems,
  ) async* {
    yield failureOrItems.fold(
      (failure) {
        return ErrorUserItems(message: _mapFailureToMessage(failure));
      },
      (response) {
        items = response;
        return LoadedUserItems(items: items);
      },
    );
  }

  Stream<UserState> _eitherUserItemDeleteOrErrorState(
    Either<Failure, String> failureOrDelete,
  ) async* {
    yield failureOrDelete.fold(
      (failure) {
        return ErrorUserItems(message: _mapFailureToMessage(failure));
      },
      (response) {
        items.removeWhere((element) => element.id == response);
        return LoadedUserItems(items: items);
      },
    );
  }

  Stream<UserState> _eitherUserFavouritesOrErrorState(
    Either<Failure, List<Picture>> failureOrFavourites,
  ) async* {
    yield failureOrFavourites.fold(
      (failure) {
        return ErrorUserItems(message: _mapFailureToMessage(failure));
      },
      (response) {
        favourites = response;
        return LoadedFavouriteItems(items: favourites);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return "error_network".tr();
      case UserItemsFailure:
        return "error_items".tr();
      default:
        return 'error_unexp'.tr();
    }
  }
}
