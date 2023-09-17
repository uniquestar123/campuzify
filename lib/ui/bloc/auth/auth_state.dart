part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

//SignInState
class LoadingSignInState extends AuthState {}

class SuccessSignInState extends AuthState {}

class ErrorSignInState extends AuthState {
  final String message;

  ErrorSignInState(this.message);
}

//SignUpState
class LoadingSignUpState extends AuthState {}

class SuccessSignUpState extends AuthState {}

class ErrorSignUpState extends AuthState {
  final String message;

  ErrorSignUpState(this.message);
}

//DemoState
class LoadingDemoAuthState extends AuthState {}

class SuccessDemoAuthState extends AuthState {}

class ErrorDemoAuthState extends AuthState {
  final String message;

  ErrorDemoAuthState(this.message);
}

//AuthSocials
class LoadingAuthGoogleState extends AuthState {}

class LoadingAuthFacebookState extends AuthState {}

class SuccessAuthSocialsState extends AuthState {
  final File? photoUrl;

  SuccessAuthSocialsState(this.photoUrl);
}

class ErrorAuthSocialsState extends AuthState {
  final String message;

  ErrorAuthSocialsState(this.message);
}
