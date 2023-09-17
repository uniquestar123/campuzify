import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@provide
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(InitialAuthState()) {
    on<SignUpEvent>((event, emit) async {
      emit(LoadingSignUpState());
      try {
        await _repository.signUp(
          event.login,
          event.email,
          event.password,
        );
        emit(SuccessSignUpState());
      } on DioError catch (e) {
        emit(ErrorSignUpState(e.response?.data['message']));
      }
    });

    on<SignInEvent>((event, emit) async {
      emit(LoadingSignInState());
      try {
        await _repository.signIn(event.login, event.password);
        emit(SuccessSignInState());
      } on DioError catch (e) {
        emit(ErrorSignInState(e.response?.data['message']));
      }
    });

    on<DemoAuthEvent>((event, emit) async {
      emit(LoadingDemoAuthState());
      try {
        preferences.setBool('demo', true);
        await _repository.demoAuth();
        emit(SuccessDemoAuthState());
      } catch (error) {
        var errorData = json.decode(error.toString());
        emit(ErrorDemoAuthState(errorData['message']));
      }
    });

    on<AuthSocialsEvent>((event, emit) async {
      if (event.providerType == 'google') {
        emit(LoadingAuthGoogleState());
      } else {
        emit(LoadingAuthFacebookState());
      }

      try {
        final response = await _repository.authSocialsUser(
          event.providerType,
          event.idToken ?? '',
          event.accessToken,
        );

        emit(SuccessAuthSocialsState(event.photoUrl));
      } catch (e) {
        emit(ErrorAuthSocialsState(e.toString()));
      }
    });

    on<CloseDialogEvent>((event, emit) {
      emit(InitialAuthState());
    });
  }
}
