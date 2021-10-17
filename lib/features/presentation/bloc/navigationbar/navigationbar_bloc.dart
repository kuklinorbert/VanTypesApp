import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigationbar_event.dart';
part 'navigationbar_state.dart';

class NavigationbarBloc extends Bloc<NavigationbarEvent, NavigationbarState> {
  NavigationbarBloc() : super(NavigationbarInitial());

  @override
  Stream<NavigationbarState> mapEventToState(
    NavigationbarEvent event,
  ) async* {
    if (event is HomeSelected) {
      yield NavigationbarHome();
    } else if (event is FavouritesSelected) {
      yield NavigationbarFavourites();
    } else if (event is GallerySelected) {
      yield NavigationbarGallery();
    } else if (event is DetectionSelected) {
      yield NavigationbarDetection();
    }
  }
}
