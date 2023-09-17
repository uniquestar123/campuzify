import 'dart:io';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/cache/account_local.dart';
import 'package:masterstudy_app/data/models/account.dart';
import 'package:masterstudy_app/data/network/api_provider.dart';

abstract class AccountRepository {
  Future<Account> getUserAccount();

  Future<Account> getAccountById(int userId);

  Future editProfile({
    String? firstName,
    String? lastName,
    String? password,
    String? description,
    String? position,
    String? facebook,
    String? twitter,
    String? instagram,
    File? photo,
  });

  Future uploadProfilePhoto(File file);

  void saveAccountLocal(Account account);

  Future<List<Account>> getAccountLocal();

  Future deleteAccount({int accountId});
}

@provide
class AccountRepositoryImpl implements AccountRepository {
  final UserApiProvider _apiProvider;
  final AccountLocalStorage _accountLocalStorage;

  AccountRepositoryImpl(this._apiProvider, this._accountLocalStorage);

  @override
  Future<Account> getAccountById(int accountId) {
    return _apiProvider.getAccount(accountId: accountId);
  }

  @override
  Future<Account> getUserAccount() {
    return _apiProvider.getAccount();
  }

  @override
  Future editProfile({
    String? firstName,
    String? lastName,
    String? password,
    String? description,
    String? position,
    String? facebook,
    String? twitter,
    String? instagram,
    File? photo,
  }) async {
    final editProfileResponse = await _apiProvider.editProfile(
      firstName!,
      lastName!,
      password!,
      description!,
      position!,
      facebook!,
      instagram!,
      twitter!,
    );

    return editProfileResponse;
  }

  @override
  Future uploadProfilePhoto(File file) async {
    try {
      final uploadPhotoResponse = await _apiProvider.uploadProfilePhoto(file);

      return uploadPhotoResponse;
    } on Error catch (e) {
      throw Exception();
    }
  }

  void saveAccountLocal(Account account) {
    return _accountLocalStorage.saveAccountLocal(account);
  }

  Future<List<Account>> getAccountLocal() async {
    return await _accountLocalStorage.getAccountLocal();
  }

  @override
  Future deleteAccount({int? accountId}) async {
    return await _apiProvider.deleteAccount(accountId: accountId);
  }
}
