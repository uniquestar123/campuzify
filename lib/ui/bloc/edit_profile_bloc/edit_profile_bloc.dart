import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/models/account.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:meta/meta.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

@provide
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AccountRepository _repository;
  late Account account;

  EditProfileBloc(this._repository) : super(InitialEditProfileState()) {
    on<SaveEvent>((event, emit) async {
      try {
        emit(LoadingEditProfileState());

        final editProfileResponse = await _repository.editProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          password: event.password,
          description: event.description,
          position: event.position,
          facebook: event.facebook,
          twitter: event.twitter,
          instagram: event.instagram,
        );

        try {
          if (event.photo != null) {
            final uploadProfileResponse = await _repository.uploadProfilePhoto(event.photo!);
          }
        } catch (e) {
          emit(ErrorEditProfileState());
        }

        emit(UpdatedEditProfileState());
      } catch (e) {
        emit(ErrorEditProfileState());
      }
    });

    on<UploadPhotoProfileEvent>((event, emit) async {
      try {
        final uploadPhotoResponse = await _repository.uploadProfilePhoto(event.photo!);
      } catch (e, s) {
        emit(ErrorEditProfileState());
      }
    });

    on<CloseScreenEvent>((event, emit) {
      emit(CloseEditProfileState());
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(LoadingDeleteAccountState());

      final response = await _repository.deleteAccount(accountId: event.accountId!);

      if (response['success'] == false) {
        emit(ErrorDeleteAccountState());
      } else {
        emit(SuccessDeleteAccountState());
      }
    });
  }
}
