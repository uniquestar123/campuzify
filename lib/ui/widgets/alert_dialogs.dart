import 'package:flutter/material.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';

showAlertDialog(
  BuildContext context, {
  String? title,
  String? content,
  VoidCallback? onPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title ?? localizations!.getLocalization("error_dialog_title"),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        content: Text(content!),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainColor,
            ),
            child: Text(
              localizations!.getLocalization("ok_dialog_button"),
              textScaleFactor: 1.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed;
            },
          ),
        ],
      );
    },
  );
}
