import 'package:bloc/bloc.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'restore_password_event.dart';

part 'restore_password_state.dart';

@provide
class RestorePasswordBloc extends Bloc<RestorePasswordEvent, RestorePasswordState> {
  final AuthRepository _authRepository;

  RestorePasswordBloc(this._authRepository) : super(InitialRestorePasswordState()) {
    on<SendRestorePasswordEvent>((event, emit) async {
      emit(LoadingRestorePasswordState());
      try {
        final restorePasswordResponse = await _authRepository.restorePassword(event.email);

        if (restorePasswordResponse['status'].toString() == 'error') {
          emit(ErrorRestorePasswordState(restorePasswordResponse['message']));
          return;
        } else {
          emit(SuccessRestorePasswordState());
        }
      } catch (e, s) {
        emit(ErrorRestorePasswordState('Error with API'));
      }
    });
  }
}
