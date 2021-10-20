import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  void toggleTheme(int isdarkmode) {
    if (isdarkmode == 1) {
      ThemeMode.dark;
    } else {
      ThemeMode.light;
    }
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(colorScheme: ColorScheme.light());
  static final darkTheme = ThemeData(colorScheme: ColorScheme.dark());
}
