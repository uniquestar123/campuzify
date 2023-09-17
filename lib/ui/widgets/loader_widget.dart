import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final Color? loaderColor;

  const LoaderWidget({Key? key, this.loaderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    } else {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loaderColor ?? Colors.white),
          ),
        ),
      );
    }
  }
}
