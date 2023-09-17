import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/course/CourcesResponse.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/theme.dart';
import 'package:masterstudy_app/ui/bloc/favorites/bloc.dart';
import 'package:masterstudy_app/ui/screens/auth/auth_screen.dart';
import 'package:masterstudy_app/ui/widgets/course_grid_item.dart';
import 'package:masterstudy_app/ui/widgets/loading_error_widget.dart';

class FavoritesScreen extends StatelessWidget {
  final OptionsBean? optionsBean;

  FavoritesScreen({this.optionsBean});

  @override
  Widget build(BuildContext context) => _FavoritesScreenWidget(optionsBean: optionsBean);
}

class _FavoritesScreenWidget extends StatefulWidget {
  final OptionsBean? optionsBean;

  _FavoritesScreenWidget({this.optionsBean});

  @override
  State<StatefulWidget> createState() => _FavoritesScreenWidgetState();
}

class _FavoritesScreenWidgetState extends State<_FavoritesScreenWidget> {
  int? selectedId;
  FavoritesBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FavoritesBloc>(context)..add(FetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#F3F5F9"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        leading: const SizedBox(),
        centerTitle: true,
        title: Text(
          localizations!.getLocalization("favorites_title"),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is EmptyFavoritesState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: SvgPicture.asset(
                      ImageVectorPath.emptyCourses,
                    ),
                  ),
                  Text(
                    localizations!.getLocalization("no_user_favorites_screen_title"),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: HexColor.fromHex("#D7DAE2"), fontSize: 18),
                  ),
                ],
              ),
            );
          }

          if (state is UnauthorizedState) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      localizations?.getLocalization("not_authenticated") ?? 'You need to login to access this content',
                      textAlign: TextAlign.center,
                    ),
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
            );
          }

          if (state is ErrorFavoritesState)
            return Center(
              child: LoadingErrorWidget(() {
                _bloc?.add(FetchFavorites());
              }),
            );

          if (state is LoadedFavoritesState) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: AlignedGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: state.favoriteCourses.length,
                itemBuilder: (context, index) {
                  var item = state.favoriteCourses[index];
                  var itemId = item!.id;
                  var itemState = CourseGridItemEditingState.primary;

                  if (selectedId == null) {
                    itemState = CourseGridItemEditingState.primary;
                  } else {
                    if (selectedId == itemId) {
                      itemState = CourseGridItemEditingState.selected;
                    } else {
                      itemState = CourseGridItemEditingState.shadowed;
                    }
                  }
                  var paddingTop = 0.0;
                  var paddingBottom = 0.0;
                  if (index < 2) paddingTop = 16.0;
                  if (index == state.favoriteCourses.length - 1) paddingBottom = 16.0;
                  return Padding(
                    padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
                    child: CourseGridItemSelectable(
                      optionsBean: widget.optionsBean!,
                      coursesBean: item,
                      onTap: () {
                        if (selectedId != itemId) {
                          setState(() {
                            selectedId = null;
                          });
                        }
                      },
                      onDeletePressed: () {
                        setState(() {
                          selectedId = null;
                        });
                        _bloc?.add(DeleteEvent(itemId));
                      },
                      onSelected: () {
                        setState(() {
                          setState(() {
                            selectedId = itemId;
                          });
                        });
                      },
                      itemState: itemState,
                    ),
                  );
                },
              ),
            );
          }

          if (state is InitialFavoritesState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center();
        },
      ),
    );
  }
}

enum CourseGridItemEditingState { primary, selected, shadowed }

class CourseGridItemSelectable extends StatelessWidget {
  final CoursesBean coursesBean;
  final OptionsBean optionsBean;
  final VoidCallback onDeletePressed;
  final VoidCallback onSelected;
  final VoidCallback onTap;
  final CourseGridItemEditingState itemState;

  const CourseGridItemSelectable({
    required this.coursesBean,
    required this.onTap,
    required this.onDeletePressed,
    required this.onSelected,
    required this.itemState,
    required this.optionsBean,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onSelected,
      onTap: onTap,
      child: Container(
        child: Stack(
          children: <Widget>[
            CourseGridItem(
              coursesBean,
              optionsBean: optionsBean,
            ),
            Visibility(
              visible: itemState == CourseGridItemEditingState.selected,
              child: Container(
                height: 212,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: AppColor.mainColor, width: 2)),
              ),
            ),
            Visibility(
              visible: itemState == CourseGridItemEditingState.selected,
              child: Positioned(
                top: 1,
                right: 1,
                child: Container(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    backgroundColor: AppColor.mainColor,
                    child: Icon(Icons.close),
                    onPressed: onDeletePressed,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: itemState == CourseGridItemEditingState.shadowed,
              child: Container(
                height: 200,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
