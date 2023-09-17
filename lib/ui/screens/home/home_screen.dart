import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/ui/bloc/home/home_bloc.dart';
import 'package:masterstudy_app/ui/widgets/loader_widget.dart';
import 'package:masterstudy_app/ui/widgets/loading_error_widget.dart';
import 'items/items.dart';

@provide
class HomeScreen extends StatefulWidget {
  final OptionsBean? optionsBean;

  const HomeScreen({this.optionsBean}) : super();

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(FetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: AppColor.mainColor,
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is InitialHomeState) {
            return LoaderWidget(
              loaderColor: AppColor.mainColor,
            );
          }

          if (state is LoadedHomeState) {
            return ListView.builder(
              itemCount: state.layout.length,
              itemBuilder: (context, index) {
                HomeLayoutBean? item = state.layout[index];
                switch (item?.id) {
                  case 1:
                    return CategoriesWidget(item?.name, state.categoryList, widget.optionsBean);
                  case 2:
                    return NewCoursesWidget(item?.name, state.coursesNew, widget.optionsBean);
                  case 3:
                    return TrendingWidget(true, item?.name, state.coursesTrending, widget.optionsBean);
                  case 4:
                    return TopInstructorsWidget(item?.name, state.instructors, widget.optionsBean);
                  case 5:
                    return TrendingWidget(false, item?.name, state.coursesFree, widget.optionsBean);
                  default:
                    return NewCoursesWidget(item?.name, state.coursesNew, widget.optionsBean);
                }
              },
            );
          }

          if (state is ErrorHomeState) {
            return LoadingErrorWidget(() {
              BlocProvider.of<HomeBloc>(context).add(FetchEvent());
            });
          }

          return LoadingErrorWidget(() {
            BlocProvider.of<HomeBloc>(context).add(FetchEvent());
          });
        },
      ),
    );
  }
}
