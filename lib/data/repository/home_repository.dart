import 'dart:developer';

import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/cache/app_settings_local.dart';
import 'package:masterstudy_app/data/cache/localization_local.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category.dart';
import 'package:masterstudy_app/data/network/api_provider.dart';

abstract class HomeRepository {
  Future<AppSettings> getAppSettings();

  Future<List<Category>> getCategories();

  Future saveLocal(AppSettings appSettings);

  Future<List<AppSettings>> getAppSettingsLocal();

  Future<Map<String, dynamic>> getAllLocalizationLocal();

  void saveLocalizationLocal(Map<String, dynamic> localizationMap);
}

@provide
@singleton
class HomeRepositoryImpl implements HomeRepository {
  final UserApiProvider apiProvider;
  final AppLocalStorage appLocalStorage;
  final LocalizationLocalStorage localizationLocalStorage;

  HomeRepositoryImpl(
    this.apiProvider,
    this.appLocalStorage,
    this.localizationLocalStorage,
  );

  @override
  Future<AppSettings> getAppSettings() async => await apiProvider.getAppSettings();

  @override
  Future<List<Category>> getCategories() {
    return apiProvider.getCategories();
  }

  Future saveLocal(AppSettings appSettings) async {
    try {
      return appLocalStorage.saveLocalAppSetting(appSettings);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<AppSettings>> getAppSettingsLocal() async {
    return await appLocalStorage.getAppSettingsLocal();
  }

  void saveLocalizationLocal(Map<String, dynamic> localizationMap) {
    try {
      return localizationLocalStorage.saveLocalizationLocal(localizationMap);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> getAllLocalizationLocal() async {
    return localizationLocalStorage.getLocalization();
  }
}
