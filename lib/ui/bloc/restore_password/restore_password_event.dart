part of 'restore_password_bloc.dart';

@immutable
abstract class RestorePasswordEvent {}

class SendRestorePasswordEvent extends RestorePasswordEvent {
  final String email;

  SendRestorePasswordEvent(this.email);
}
