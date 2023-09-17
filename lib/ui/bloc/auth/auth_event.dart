part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String login;
  final String password;

  SignInEvent(this.login, this.password);
}

class SignUpEvent extends AuthEvent {
  final String login;
  final String email;
  final String password;

  SignUpEvent(this.login, this.email, this.password);
}

class AuthSocialsEvent extends AuthEvent {
  final String providerType;
  final String? idToken;
  final String accessToken;
  final File? photoUrl;

  AuthSocialsEvent({
    required this.providerType,
    this.idToken,
    required this.accessToken,
    this.photoUrl,
  });
}

class CloseDialogEvent extends AuthEvent {}

class DemoAuthEvent extends AuthEvent {}
