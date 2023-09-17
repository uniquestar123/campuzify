import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:inject/inject.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/network/api_provider.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';

part 'splash_state.dart';

@provide
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final HomeRepository _homeRepository;
  final UserApiProvider _apiProvider;

  SplashBloc(this._homeRepository, this._apiProvider) : super(InitialSplashState()) {
    on<LoadSplashEvent>((event, emit) async {
      emit(LoadingSplashState());

      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

      /// Если есть подключение к сети, то вызываем getAppSettings()
      /// и сразу загружаем кэш в appSettingsLocal()
      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        try {
          // Localizations load
          Map<String, dynamic> locale = await _apiProvider.getLocalization();

          _homeRepository.saveLocalizationLocal(locale);

          localizations?.saveCustomLocalization(locale);

          // AppSettings load
          AppSettings appSettings = await _homeRepository.getAppSettings();

          _homeRepository.saveLocal(appSettings);

          if (appSettings.options!.logo != null) {
            appLogoUrl = appSettings.options!.logo;
          }

          demoEnabled = appSettings.demo ?? false;
          googleOauth = appSettings.options?.google_oauth ?? false;
          facebookOauth = appSettings.options?.facebook_oauth ?? false;

          ///Addons about count course
          if (appSettings.addons != null) {
            dripContentEnabled = appSettings.addons?.sequential_drip_content != null &&
                appSettings.addons?.sequential_drip_content == "on";
          }

          /// Если [main_color] у нас не null, то вызываем функцию ColorRGB
          /// Если [main_color] null, то вызываем функцию ColorHex
          if (appSettings.options?.main_color != null) {
            AppColor().setMainColorRGB(appSettings.options!.main_color!);
          } else if (appSettings.options?.main_color_hex != null) {
            AppColor().setMainColorHex(appSettings.options!.main_color_hex!);
          }

          /// Если [secondary_color] не null, то вызываем функцию ColorRGB
          if (appSettings.options?.secondary_color != null) {
            AppColor().setSecondaryColorRGB(appSettings.options!.secondary_color!);
          }

          emit(CloseSplashState(appSettings));
        } catch (e) {
          emit(ErrorSplashState('Unknown Error, please try later'));
        }
      } else {
        var locale = await _homeRepository.getAllLocalizationLocal();

        localizations?.saveCustomLocalization(locale);

        List<AppSettings> appSettingLocal = await _homeRepository.getAppSettingsLocal();

        if (appSettingLocal.first.options!.logo != null) {
          appLogoUrl = appSettingLocal.first.options!.logo;
        }

        demoEnabled = appSettingLocal.first.demo ?? false;
        googleOauth = appSettingLocal.first.options?.google_oauth ?? false;
        facebookOauth = appSettingLocal.first.options?.facebook_oauth ?? false;

        ///Addons about count course
        if (appSettingLocal.first.addons != null) {
          dripContentEnabled = appSettingLocal.first.addons?.sequential_drip_content != null &&
              appSettingLocal.first.addons?.sequential_drip_content == "on";
        }

        /// Если [main_color] у нас не null, то вызываем функцию ColorRGB
        /// Если [main_color] null, то вызываем функцию ColorHex
        if (appSettingLocal.first.options?.main_color != null) {
          AppColor().setMainColorRGB(appSettingLocal.first.options!.main_color!);
        } else if (appSettingLocal.first.options?.main_color_hex != null) {
          AppColor().setMainColorHex(appSettingLocal.first.options!.main_color_hex!);
        }

        /// Если [secondary_color] не null, то вызываем функцию ColorRGB
        if (appSettingLocal.first.options?.secondary_color != null) {
          AppColor().setSecondaryColorRGB(appSettingLocal.first.options!.secondary_color!);
        }

        emit(CloseSplashState(appSettingLocal.first));
      }
    });
  }
}
