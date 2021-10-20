import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vantypesapp/core/util/themes.dart';
import 'package:vantypesapp/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:vantypesapp/features/presentation/pages/detection_page.dart';
import 'package:vantypesapp/features/presentation/pages/favourites_page.dart';
import 'package:vantypesapp/features/presentation/pages/categories_page.dart';
import 'package:vantypesapp/features/presentation/pages/home_page.dart';
import 'package:vantypesapp/features/presentation/widgets/navbar.dart';
import 'package:vantypesapp/main.dart';

import '../../../../injection_container.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AuthBloc authBloc;
  NavigationbarBloc navbarBloc;
  PageController _pageController;
  bool isDark = darkNotifier.value;

  @override
  void initState() {
    authBloc = sl<AuthBloc>();
    navbarBloc = sl<NavigationbarBloc>();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _storeOnboardInfo(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel;
    return Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: 50, left: 15),
            children: [
              Text(
                FirebaseAuth.instance.currentUser.displayName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              Text(
                "theme".tr(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              ListTile(
                title: Text(
                  "dark_mode".tr(),
                  style: TextStyle(fontSize: 16),
                ),
                trailing: ToggleSwitch(
                  minHeight: 35,
                  minWidth: 60,
                  activeFgColor: Colors.green[300],
                  activeBgColor: [Theme.of(context).backgroundColor],
                  inactiveBgColor: Colors.grey[300],
                  radiusStyle: true,
                  totalSwitches: 2,
                  cornerRadius: 25,
                  initialLabelIndex: isDark ? 1 : 0,
                  customIcons: [
                    Icon(Icons.light_mode_outlined),
                    Icon(Icons.dark_mode_outlined)
                  ],
                  onToggle: (index) {
                    if (index == 0) {
                      isDark = false;
                    } else {
                      isDark = true;
                    }
                    _storeOnboardInfo(isDark);
                    darkNotifier.value = isDark;
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              Text(
                "lang".tr(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text(
                  "en".tr(),
                  style: (EasyLocalization.of(context).locale.toString() ==
                          "en")
                      ? TextStyle(fontSize: 17, fontWeight: FontWeight.w500)
                      : TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  EasyLocalization.of(context).setLocale(Locale('en'));
                },
              ),
              ListTile(
                title: Text('hu'.tr(),
                    style: (EasyLocalization.of(context).locale.toString() ==
                            "hu")
                        ? TextStyle(fontSize: 17, fontWeight: FontWeight.w500)
                        : TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                onTap: () {
                  EasyLocalization.of(context).setLocale(Locale('hu'));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "logout".tr(),
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);

                  authBloc.add(LogoutEvent());
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('VanTypesApp'),
        ),
        body: BlocListener<NavigationbarBloc, NavigationbarState>(
            bloc: navbarBloc,
            listener: (context, state) {
              if (state is NavigationbarHome || state is NavigationbarInitial) {
                _pageController.jumpToPage(0);
              }
              if (state is NavigationbarDetection) {
                _pageController.jumpToPage(1);
              }

              if (state is NavigationbarGallery) {
                _pageController.jumpToPage(2);
              }
              if (state is NavigationbarFavourites) {
                _pageController.jumpToPage(3);
              }
            },
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                if (index == 0) navbarBloc.add(HomeSelected());
                if (index == 1) navbarBloc.add(DetectionSelected());
                if (index == 2) navbarBloc.add(GallerySelected());
                if (index == 3) navbarBloc.add(FavouritesSelected());
              },
              children: [
                HomePage(),
                DetectionPage(),
                CategoriesPage(),
                FavouritesPage()
              ],
            )),
        bottomNavigationBar: BlocBuilder<NavigationbarBloc, NavigationbarState>(
          bloc: navbarBloc,
          builder: (context, state) {
            if (state is NavigationbarHome || state is NavigationbarInitial) {
              return buildNavbar(navbarBloc, 0);
            }
            if (state is NavigationbarDetection) {
              return buildNavbar(navbarBloc, 1);
            }
            if (state is NavigationbarGallery) {
              return buildNavbar(navbarBloc, 2);
            }
            if (state is NavigationbarFavourites) {
              return buildNavbar(navbarBloc, 3);
            }
            return Container();
          },
        ));
  }
}
