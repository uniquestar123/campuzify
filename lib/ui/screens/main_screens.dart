import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/ui/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/ui/screens/courses/courses_screen.dart';
import 'package:masterstudy_app/ui/screens/favorites/favorites_screen.dart';
import 'package:masterstudy_app/ui/screens/home/home_screen.dart';
import 'package:masterstudy_app/ui/screens/home_simple/home_simple_screen.dart';
import 'package:masterstudy_app/ui/screens/profile/profile_screen.dart';
import 'package:masterstudy_app/ui/screens/search/search_screen.dart';

class MainScreenArgs {
  final OptionsBean optionsBean;
  final int? selectedIndex;

  MainScreenArgs(this.optionsBean, {this.selectedIndex});
}

class MainScreen extends StatelessWidget {
  static const routeName = "mainScreen";

  const MainScreen() : super();

  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    return MainScreenWidget(args.optionsBean, selectedIndex: args.selectedIndex);
  }
}

class MainScreenWidget extends StatefulWidget {
  final OptionsBean optionsBean;
  final int? selectedIndex;

  const MainScreenWidget(this.optionsBean, {this.selectedIndex}) : super();

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreenWidget> {
  int _selectedIndex = 0;
  final _selectedItemColor = AppColor.mainColor;
  final _unselectedItemColor = AppColor.unselectedColor;

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        selectedFontSize: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(ImageVectorPath.navHome, localizations!.getLocalization("home_bottom_nav"), 0),
            label: localizations!.getLocalization("home_bottom_nav"),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(ImageVectorPath.navCourses, localizations!.getLocalization("search_bottom_nav"), 1),
            label: localizations!.getLocalization("search_bottom_nav"),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(ImageVectorPath.navPlay, localizations!.getLocalization("courses_bottom_nav"), 2),
            label: localizations!.getLocalization("courses_bottom_nav"),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(ImageVectorPath.navFavourites, localizations!.getLocalization("favorites_bottom_nav"), 3),
            label: localizations!.getLocalization("favorites_bottom_nav"),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(ImageVectorPath.navProfile, localizations!.getLocalization("profile_bottom_nav"), 4),
            label: localizations!.getLocalization("profile_bottom_nav"),
          ),
        ],
      ),
    );
  }

  Color? _getItemColor(int index) => _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;

  Widget _buildIcon(String iconData, String text, int index) => SizedBox(
        height: kBottomNavigationBarHeight,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });

            //Function for if user not access token, show auth screen when tap on bottom navigation(profile)
            if (index == 4) {
              if (preferences.getString('apiToken') == null || preferences.getString('apiToken') == '') {
                Navigator.pushNamed(
                  context,
                  AuthScreen.routeName,
                  arguments: AuthScreenArgs(optionsBean: widget.optionsBean, withoutToken: true),
                );
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 2.0, bottom: 4.0),
                child: SvgPicture.asset(
                  iconData,
                  height: 22.0,
                  color: _getItemColor(index),
                ),
              ),
              Text(
                text,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 12,
                  color: _getItemColor(index),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return widget.optionsBean.app_view
            ? HomeSimpleScreen(widget.optionsBean)
            : HomeScreen(optionsBean: widget.optionsBean);
      case 1:
        return SearchScreen();

      case 2:
        return CoursesScreen(
          () {
            setState(() {
              _selectedIndex = 0;
            });
          },
          optionsBean: widget.optionsBean,
        );
      case 3:
        return FavoritesScreen(optionsBean: widget.optionsBean);
      case 4:
        return ProfileScreen(
          () {
            setState(() {
              _selectedIndex = 2;
            });
          },
        );
      default:
        return Center(
          child: Text(
            "Not implemented!",
            textScaleFactor: 1.0,
          ),
        );
    }
  }
}
