import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/usecases/favourites/add_favourite.dart'
    as addFav;
import 'package:vantypesapp/features/domain/usecases/favourites/get_favourites.dart'
    as getFav;
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/domain/usecases/favourites/remove_favourite.dart'
    as remFav;

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final getFav.GetFavourites _getFavourites;
  final addFav.AddFavourite _addFavourite;
  final remFav.RemoveFavourite _removeFavourite;
  List<String> userFavourites = [];

  FavouritesBloc(
      {@required getFav.GetFavourites getFavourites,
      @required addFav.AddFavourite addFavourite,
      @required remFav.RemoveFavourite removeFavourite})
      : _getFavourites = getFavourites,
        _addFavourite = addFavourite,
        _removeFavourite = removeFavourite,
        super(FavouritesInitial());

  @override
  Stream<FavouritesState> mapEventToState(FavouritesEvent event) async* {
    if (event is GetFavouritesEvent) {
      final failureOrFavourites =
          await _getFavourites.call(getFav.Params(uid: event.uid));
      yield* _eitherListOrErrorState(failureOrFavourites);
    }
    if (event is AddFavouriteEvent) {
      final failureOrAdd = await _addFavourite
          .call(addFav.Params(uid: event.uid, itemId: event.itemId));
      yield* _eitherAddOrErrorState(failureOrAdd);
    }
    if (event is RemoveFavouriteEvent) {
      final failureOrRemove = await _removeFavourite
          .call(remFav.Params(uid: event.uid, itemId: event.itemId));
      yield* _eitherRemoveOrErrorState(failureOrRemove);
    }
  }

  Stream<FavouritesState> _eitherListOrErrorState(
    Either<Failure, List<String>> failureOrFavourites,
  ) async* {
    yield failureOrFavourites.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (response) {
        userFavourites = response;
        return FavouritesFetchedState(favourites: response);
      },
    );
  }

  Stream<FavouritesState> _eitherAddOrErrorState(
    Either<Failure, String> failureOrFavourites,
  ) async* {
    yield failureOrFavourites.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (response) {
        userFavourites.add(response);
        return AddedFavourite(itemId: response);
      },
    );
  }

  Stream<FavouritesState> _eitherRemoveOrErrorState(
    Either<Failure, String> failureOrFavourites,
  ) async* {
    yield failureOrFavourites.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (response) {
        userFavourites.remove(response);
        return RemovedFavourite(itemId: response);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return "network_fail".tr();
      case FavouritesFailure:
        return "favourites_fail".tr();
      default:
        return 'unexp_fail'.tr();
    }
  }
}
