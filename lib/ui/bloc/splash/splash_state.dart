part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class InitialSplashState extends SplashState {}

class LoadingSplashState extends SplashState {}

class CloseSplashState extends SplashState {
  final AppSettings? appSettings;

  CloseSplashState(this.appSettings);
}

class ErrorSplashState extends SplashState {
  final String? message;

  ErrorSplashState(this.message);
}
