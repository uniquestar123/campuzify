import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/theme.dart';
import 'package:masterstudy_app/ui/bloc/profile/bloc.dart';
import 'package:masterstudy_app/ui/screens/detail_profile/detail_profile_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProfileWidget extends StatelessWidget {
  final OptionsBean? optionsBean;

  const ProfileWidget({Key? key, this.optionsBean}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is LoadedProfileState) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                DetailProfileScreen.routeName,
                arguments: DetailProfileScreenArgs(state.account, optionsBean),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    child: CachedNetworkImage(
                      width: 50.0,
                      fit: BoxFit.fill,
                      imageUrl: state.account.avatar_url!,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return SizedBox(
                          width: 50.0,
                          child: Image.asset(ImageRasterPath.logo),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          localizations!.getLocalization("greeting_user"),
                          textScaleFactor: 1.0,
                          style: Theme.of(context).primaryTextTheme.subtitle2!.copyWith(
                                color: HexColor.fromHex("#AAAAAA"),
                              ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 28,
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 110),
                          child: Text(
                            (state.account.meta!.first_name != '' && state.account.meta!.last_name != '')
                                ? "${state.account.meta!.first_name} ${state.account.meta!.last_name}"
                                : state.account.login!,
                            textScaleFactor: 1.0,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).primaryTextTheme.headline5!.copyWith(color: dark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          height: 90,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[200]!,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.amber),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 15,
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(color: Colors.green),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
