import 'package:flutter/material.dart';
import 'package:masterstudy_app/data/core/extensions/color_extensions.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';

class AppColor {
  static const bgColor = Color(0xffffffff);
  static Color mainColor = Color(0xff195ec8);
  static Color secondaryColor = Color(0xff17d292);
  static Color redColor = Color(0xffFF3B30);


  // BottomNavigationBar Color
  static Color unselectedColor = Colors.grey;

  void setMainColorRGB(ColorBean colorBean) {
    mainColor = Color.fromRGBO(
      colorBean.r.toInt(),
      colorBean.g.toInt(),
      colorBean.b.toInt(),
      0.999,
    );
  }

  void setMainColorHex(String mainColorHex) {
    mainColor = HexColor.fromHex(mainColorHex);
  }

  void setSecondaryColorRGB(ColorBean colorBean) {
    secondaryColor = Color.fromRGBO(
      colorBean.r.toInt(),
      colorBean.g.toInt(),
      colorBean.b.toInt(),
      0.999,
    );
  }
}
