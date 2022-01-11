import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
      colorScheme: ColorScheme.light(
          primary: const Color(0xfff68e56),
          secondary: const Color(0xff56bef6)));
  static final darkTheme = ThemeData(
      colorScheme: ColorScheme.dark(
          primary: const Color(0xff566ef6),
          secondary: const Color(0xfff6de56),
          secondaryVariant: const Color(0xfff6de56)));
}
