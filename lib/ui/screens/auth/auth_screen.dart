import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/ui/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/ui/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/ui/screens/main_screens.dart';
import 'widget/sign_in.dart';
import 'widget/sign_up.dart';

class AuthScreenArgs {
  final OptionsBean? optionsBean;
  final bool withoutToken;

  AuthScreenArgs({this.optionsBean, this.withoutToken = false});
}

@provide
class AuthScreen extends StatelessWidget {
  final AuthBloc _bloc;
  final EditProfileBloc _editProfileBloc;

  static const routeName = "authScreen";

  AuthScreen(this._bloc, this._editProfileBloc);

  @override
  Widget build(BuildContext context) {
    final AuthScreenArgs args = ModalRoute.of(context)?.settings.arguments as AuthScreenArgs;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _bloc,
        ),
        BlocProvider(
          create: (context) => _editProfileBloc,
        ),
      ],
      child: AuthScreenWidget(
        optionsBean: args.optionsBean!,
        withoutToken: args.withoutToken,
        key: key,
      ),
    );
  }
}

class AuthScreenWidget extends StatelessWidget {
  final OptionsBean optionsBean;
  final bool withoutToken;

  const AuthScreenWidget({
    Key? key,
    required this.optionsBean,
    required this.withoutToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0), // here th
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColor.mainColor,
              ),
              onPressed: () {
                if (withoutToken) {
                  Navigator.of(context).pushReplacementNamed(
                    MainScreen.routeName,
                    arguments: MainScreenArgs(optionsBean),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: CachedNetworkImage(
                width: 50.0,
                imageUrl: appLogoUrl ?? '',
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  return SizedBox(
                    width: 83.0,
                    child: Image.asset(ImageRasterPath.logo),
                  );
                },
              ),
            ),
            bottom: TabBar(
              indicatorColor: AppColor.mainColor,
              tabs: [
                //SignUp
                Tab(
                  icon: Text(
                    localizations!.getLocalization("auth_sign_up_tab"),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: AppColor.mainColor),
                  ),
                ),
                //SignIn
                Tab(
                  icon: Text(
                    localizations!.getLocalization("auth_sign_in_tab"),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: AppColor.mainColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              //SignUp
              ListView(
                children: <Widget>[
                  SignUpPage(
                    optionsBean: optionsBean,
                  )
                ],
              ),
              //SignIn
              ListView(
                children: <Widget>[
                  SignInPage(
                    optionsBean: optionsBean,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
