import 'package:bloc/bloc.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/models/InstructorsResponse.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category.dart';
import 'package:masterstudy_app/data/models/course/CourcesResponse.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';
import 'package:masterstudy_app/data/repository/instructors_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

@provide
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final CoursesRepository _coursesRepository;
  final InstructorsRepository _instructorsRepository;

  HomeBloc(this._homeRepository, this._coursesRepository, this._instructorsRepository) : super(InitialHomeState()) {
    on<FetchEvent>((event, emit) async {
      List<HomeLayoutBean?> layouts;

      try {
        AppSettings appSettings = await _homeRepository.getAppSettings();

        // Проверка, если enabled == false, то удаляем
        layouts = appSettings.home_layout;

        layouts.removeWhere((element) => element!.enabled == false);

        List<Category> categories = await _homeRepository.getCategories();
        var coursesFree = await _coursesRepository.getCourses(sort: Sort.free);
        var coursesNew = await _coursesRepository.getCourses(sort: Sort.date_low);
        var coursesTrending = await _coursesRepository.getCourses(sort: Sort.rating);
        var instructors = await _instructorsRepository.getInstructors(InstructorsSort.rating);

        emit(
          LoadedHomeState(
            categoryList: categories,
            coursesTrending: coursesTrending.courses,
            layout: layouts,
            coursesNew: coursesNew.courses,
            coursesFree: coursesFree.courses,
            instructors: instructors,
            appSettings: appSettings,
          ),
        );
      } catch (error, stacktrace) {
        print('!!! Error: ${error}, Stacktrace: ${stacktrace} !!!');

        emit(ErrorHomeState());
      }
    });
  }
}
