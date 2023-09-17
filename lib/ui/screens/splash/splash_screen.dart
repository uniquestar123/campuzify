import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/ui/bloc/splash/splash_bloc.dart';
import 'package:masterstudy_app/ui/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/ui/screens/main_screens.dart';
import 'package:masterstudy_app/ui/widgets/loader_widget.dart';
import 'package:masterstudy_app/ui/widgets/loading_error_widget.dart';

@provide
class SplashScreen extends StatelessWidget {
  static const String routeName = "splashScreen";
  final SplashBloc bloc;

  SplashScreen(this.bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => bloc,
        child: SplashWidget(),
      ),
    );
  }
}

class SplashWidget extends StatefulWidget {
  @override
  State<SplashWidget> createState() => SplashWidgetState();
}

class SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
    BlocProvider.of<SplashBloc>(context).add(LoadSplashEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is CloseSplashState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Navigator.of(context).pushReplacementNamed(
                MainScreen.routeName,
                arguments: MainScreenArgs(state.appSettings!.options!),
              );
            },
          );
        }
      },
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          if (state is InitialSplashState) {
            return LoaderWidget();
          }

          if (state is ErrorSplashState) {
            return LoadingErrorWidget(() {
              BlocProvider.of<SplashBloc>(context).add(LoadSplashEvent());
            });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: appLogoUrl ?? '',
                  placeholder: (context, url) {
                    return LoaderWidget();
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(ImageRasterPath.logo);
                  },
                  width: 83.0,
                ),
                //Count course
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: state is LoadingSplashState
                      ? LoaderWidget(loaderColor: AppColor.mainColor)
                      : Text(
                          state is CloseSplashState ? state.appSettings!.options!.posts_count.toString() : '',
                          textScaleFactor: 1.0,
                          style: TextStyle(color: AppColor.mainColor, fontSize: 40.0),
                        ),
                ),
                //Text "Course"
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: state is CloseSplashState
                      ? Text(
                          localizations?.getLocalization('profile_courses_tab').toUpperCase() ?? "COURSES",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void openAuthPage(OptionsBean? optionsBean) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushReplacementNamed(AuthScreen.routeName, arguments: AuthScreenArgs(optionsBean: optionsBean));
    });
  }

  void openMainPage(OptionsBean? optionsBean) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(MainScreen.routeName, arguments: MainScreenArgs(optionsBean!));
      });
    });
  }
}
