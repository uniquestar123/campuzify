import 'dart:convert';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/utils.dart';

@provide
@singleton
class AppLocalStorage {
  List<AppSettings> getAppSettingsLocal() {
    try {
      List<String>? cached = preferences.getStringList('appSettings');
      cached ??= [];

      return cached.map((json) => AppSettings.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      throw Exception();
    }
  }

  void saveLocalAppSetting(AppSettings appSettings) {
    String json = jsonEncode(appSettings.toJson());

    List<String>? cachedApp = preferences.getStringList('appSettings');

    cachedApp ??= [];

    cachedApp = [];
    cachedApp.add(json);

    preferences.setStringList('appSettings', cachedApp);
  }
}
