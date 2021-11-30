import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vantypesapp/core/util/themes.dart';
import 'package:vantypesapp/features/presentation/pages/category_images_page.dart';
import 'package:vantypesapp/features/presentation/pages/login_page.dart';
import 'package:vantypesapp/features/presentation/pages/controller_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vantypesapp/features/presentation/pages/registration_page.dart';
import 'injection_container.dart' as di;

int selectedTheme;
final darkNotifier = ValueNotifier<bool>(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  bool memory = prefs.getBool('isDark');
  if (memory != null && memory) {
    darkNotifier.value = true;
  }
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('hu')],
      fallbackLocale: Locale('en'),
      path: 'assets/translations',
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: darkNotifier,
        builder: (BuildContext context, bool isDark, Widget child) {
          return MaterialApp(
            title: 'VanTypesApp',
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: MyThemes.darkTheme,
            theme: MyThemes.lightTheme,
            home: LoginPage(),
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => RegistrationPage(),
              '/main': (context) => MainPage(),
              '/category': (context) => CategoryImagesPage(),
            },
          );
        });
  }
}
