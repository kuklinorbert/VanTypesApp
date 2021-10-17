import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/features/presentation/pages/detection_page.dart';
import 'package:vantypesapp/features/presentation/pages/login_page.dart';
import 'package:vantypesapp/features/presentation/pages/controller_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('hu')],
      fallbackLocale: Locale('en'),
      path: 'assets/translations',
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VanTypesApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => MainPage(),
      },
    );
  }
}
