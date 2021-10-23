import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/domain/entities/favourites.dart';
import 'package:vantypesapp/features/domain/usecases/add_favourite.dart'
    as addFav;
import 'package:vantypesapp/features/domain/usecases/get_favourites.dart'
    as getFav;
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/domain/usecases/remove_favourite.dart'
    as remFav;

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final getFav.GetFavourites _getFavourites;
  final addFav.AddFavourite _addFavourite;
  final remFav.RemoveFavourite _removeFavourite;
  List<String> userFavourites;

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
      yield AddingFavourites();
      final failureOrAdd = await _addFavourite
          .call(addFav.Params(uid: event.uid, itemId: event.itemId));
      yield* _eitherListOrErrorState(failureOrAdd);
    }
    if (event is RemoveFavouriteEvent) {
      yield RemovingFavourites();
      final failureOrRemove = await _removeFavourite
          .call(remFav.Params(uid: event.uid, itemId: event.itemId));
      yield* _eitherListOrErrorState(failureOrRemove);
    }
  }

  Stream<FavouritesState> _eitherListOrErrorState(
    Either<Failure, Favourites> failureOrFavourites,
  ) async* {
    yield failureOrFavourites.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (response) {
        userFavourites = response.favourites;
        return FavouritesFetchedState(favourites: response);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return "error_network".tr();
      case FavouritesFailure:
        return "error_server".tr();
      default:
        return 'error_unexp'.tr();
    }
  }
}
