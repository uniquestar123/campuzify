import 'package:flutter/material.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class MetaIcon extends StatelessWidget {
  final String tag;

  const MetaIcon(this.tag) : super();

  @override
  Widget build(BuildContext context) {
    String? assetName;

    switch (tag) {
      case 'current_students':
        assetName = ImageRasterPath.enrolled;
        break;
      case 'duration':
        assetName = ImageRasterPath.duration;
        break;
      case 'curriculum':
        assetName = ImageRasterPath.lectures;
        break;
      case 'video_duration':
        assetName = ImageRasterPath.videoCurriculum;
        break;
      case 'level':
        assetName = ImageRasterPath.level;
        break;
    }

    return Image.asset(
      assetName!,
      width: 24,
      height: 24,
      color: AppColor.mainColor,
    );
  }
}
