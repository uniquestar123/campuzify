import 'package:bloc/bloc.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/utils.dart';
import './bloc.dart';

@provide
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final CoursesRepository coursesRepository;

  FavoritesState get initialState => InitialFavoritesState();

  FavoritesBloc(this.coursesRepository) : super(InitialFavoritesState()) {
    on<FetchFavorites>((event, emit) async {
      if (state is ErrorFavoritesState) emit(InitialFavoritesState());

      if (preferences.getString('apiToken') == null || preferences.getString('apiToken') == '') {
        emit(UnauthorizedState());
      } else {
        try {
          var courses = await coursesRepository.getFavoriteCourses();
          if (courses.courses.isNotEmpty) {
            emit(LoadedFavoritesState(courses.courses));
          } else {
            emit(EmptyFavoritesState());
          }
        } catch (_) {
          emit(ErrorFavoritesState());
        }
      }
    });

    on<DeleteEvent>((event, emit) async {
      try {
        var courses = (state as LoadedFavoritesState).favoriteCourses;
        courses.removeWhere((item) => item?.id == event.courseId);
        await coursesRepository.deleteFavoriteCourse(event.courseId);
        emit(LoadedFavoritesState(courses));
      } catch (_) {}
    });
  }
}
