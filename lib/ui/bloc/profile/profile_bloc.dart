import 'package:bloc/bloc.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/models/account.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:masterstudy_app/data/utils.dart';

import './bloc.dart';

@provide
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountRepository _accountRepository;
  final AuthRepository _authRepository;
  Account? account;

  ProfileBloc(this._accountRepository, this._authRepository) : super(InitialProfileState()) {
    on<FetchProfileEvent>((event, emit) async {
      emit(InitialProfileState());

      if (preferences.getString('apiToken') == null || preferences.getString('apiToken') == '') {
        emit(UnauthorizedState());
      } else {
        try {
          Account account = await _accountRepository.getUserAccount();
          _accountRepository.saveAccountLocal(account);

          emit(LoadedProfileState(account));
        } catch (error, stacktrace) {
          List<Account> accountLocal = await _accountRepository.getAccountLocal();

          emit(LoadedProfileState(accountLocal.first));
          print(error);
          print(stacktrace);
        }
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(InitialProfileState());
      try {
        Account account = await _accountRepository.getUserAccount();
        emit(LoadedProfileState(account));
      } catch (exception, stacktrace) {
        print(exception);
        print(stacktrace);
      }
    });

    on<LogoutProfileEvent>((event, emit) async {
      await _authRepository.logout();
      emit(LogoutProfileState());
    });
  }
}
