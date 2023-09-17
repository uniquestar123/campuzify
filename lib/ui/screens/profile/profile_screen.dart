import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/ui/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/theme.dart';
import 'package:masterstudy_app/ui/bloc/profile/bloc.dart';
import 'package:masterstudy_app/ui/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/ui/screens/detail_profile/detail_profile_screen.dart';
import 'package:masterstudy_app/ui/screens/orders/orders.dart';
import 'package:masterstudy_app/ui/screens/profile/widgets/profile_widget.dart';
import 'package:masterstudy_app/ui/screens/profile/widgets/tile_item.dart';
import 'package:masterstudy_app/ui/screens/profile_edit/profile_edit_screen.dart';
import 'package:masterstudy_app/ui/screens/splash/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Function myCoursesCallback;
  final OptionsBean? optionsBean;

  const ProfileScreen(this.myCoursesCallback, {this.optionsBean}) : super();

  @override
  Widget build(BuildContext context) => ProfileScreenWidget(myCoursesCallback, optionsBean: optionsBean);
}

class ProfileScreenWidget extends StatefulWidget {
  final Function myCoursesCallback;
  final OptionsBean? optionsBean;

  const ProfileScreenWidget(this.myCoursesCallback, {this.optionsBean}) : super();

  @override
  State<StatefulWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget> {
  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<ProfileBloc>(context).state is! LoadedProfileState) {
      BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<ProfileBloc>(context),
      listener: (context, state) {
        if (state is LogoutProfileState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.of(context).pushNamedAndRemoveUntil(
              SplashScreen.routeName,
              (Route<dynamic> route) => false,
            ),
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          if (state is InitialProfileState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UnauthorizedState) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: AppBar(
                  backgroundColor: AppColor.mainColor,
                ),
              ),
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(localizations?.getLocalization("not_authenticated") ??
                          'You need to login to access this content'),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.mainColor,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AuthScreen.routeName,
                            arguments: AuthScreenArgs(optionsBean: widget.optionsBean),
                          );
                        },
                        child: Text(localizations?.getLocalization("login_label_text") ?? 'Login'),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: AppColor.mainColor,
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    //Header Profile
                    BlocProvider.value(
                      value: BlocProvider.of<ProfileBloc>(context),
                      child: ProfileWidget(
                        optionsBean: widget.optionsBean,
                      ),
                    ),

                    //Divider
                    Divider(
                      height: 5.0,
                      thickness: 1.0,
                      color: HexColor.fromHex("#E5E5E5"),
                    ),

                    //View my profile
                    TileWidget(
                      title: localizations!.getLocalization("view_my_profile"),
                      assetPath: ImageVectorPath.profileIcon,
                      onClick: () {
                        if (state is LoadedProfileState)
                          Navigator.pushNamed(
                            context,
                            DetailProfileScreen.routeName,
                            arguments: DetailProfileScreenArgs(state.account, widget.optionsBean),
                          );
                      },
                    ),

                    //My orders
                    TileWidget(
                      title: localizations!.getLocalization("my_orders"),
                      assetPath: ImageVectorPath.orders,
                      onClick: () {
                        Navigator.of(context).pushNamed(OrdersScreen.routeName);
                      },
                    ),

                    //My courses
                    TileWidget(
                      title: localizations!.getLocalization("my_courses"),
                      assetPath: ImageVectorPath.navCourses,
                      onClick: () => this.widget.myCoursesCallback(),
                    ),

                    //Settings
                    TileWidget(
                      title: localizations!.getLocalization("settings"),
                      assetPath: ImageVectorPath.settings,
                      onClick: () async {
                        if (state is LoadedProfileState) {
                          Navigator.pushNamed(
                            context,
                            ProfileEditScreen.routeName,
                            arguments: ProfileEditScreenArgs(state.account),
                          );
                        }
                      },
                    ),

                    //Logout
                    TileWidget(
                      title: localizations!.getLocalization("logout"),
                      assetPath: ImageVectorPath.logout,
                      onClick: () => _showLogoutDialog(context),
                      textColor: lipstick,
                      iconColor: lipstick,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations!.getLocalization("logout"),
            textScaleFactor: 1.0,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          content: Text(
            localizations!.getLocalization("logout_message"),
            textScaleFactor: 1.0,
          ),
          actions: [
            TextButton(
              child: Text(
                localizations!.getLocalization("cancel_button"),
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: AppColor.mainColor,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                localizations!.getLocalization("logout"),
                textScaleFactor: 1.0,
                style: TextStyle(color: AppColor.mainColor),
              ),
              onPressed: () {
                GoogleSignInProvider().logoutGoogle();
                BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
