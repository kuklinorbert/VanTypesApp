import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/presentation/bloc/navigationbar/navigationbar_bloc.dart';

BottomNavigationBar buildNavbar(NavigationbarBloc navbarBloc, int index) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (index) {
      if (index == 0) navbarBloc.add(HomeSelected());
      if (index == 1) navbarBloc.add(DetectionSelected());
      if (index == 2) navbarBloc.add(GallerySelected());
      if (index == 3) navbarBloc.add(FavouritesSelected());
    },
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'home'.tr()),
      BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'detect'.tr()),
      BottomNavigationBarItem(
          icon: Icon(Icons.collections), label: 'gallery'.tr()),
      BottomNavigationBarItem(
          icon: Icon(Icons.favorite), label: 'favourites'.tr()),
    ],
  );
}
