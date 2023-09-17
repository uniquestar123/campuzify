part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class UploadPhotoProfileEvent extends EditProfileEvent {
  final File? photo;

  UploadPhotoProfileEvent(this.photo);
}

class SaveEvent extends EditProfileEvent {
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? description;
  final String? position;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final File? photo;
  final bool onlyPhoto;

  SaveEvent({
    this.firstName,
    this.lastName,
    this.password,
    this.description,
    this.position,
    this.facebook,
    this.twitter,
    this.instagram,
    this.photo,
    this.onlyPhoto = false,
  });
}

class DeleteAccountEvent extends EditProfileEvent {
  final int? accountId;

  DeleteAccountEvent({this.accountId});
}

class CloseScreenEvent extends EditProfileEvent {}
