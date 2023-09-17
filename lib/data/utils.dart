import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:masterstudy_app/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension QueryParameterAdd on Map {
  addParam(key, value) {
    if (value != null) {
      this[key] = value;
    }
  }
}

/// Url image to File type
Future<File> urlToFile(String imageUrl) async {
// generate random number.
  var rng = new Random();
// get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
  final Response response = await Dio().get<List<int>>(
    imageUrl,
    options: Options(
      responseType: ResponseType.bytes,
    ),
  );
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.data);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}

/// Validate form for email
String? validateEmail(String? value) {
  if (value!.isEmpty) {
    // The form is empty
    return localizations!.getLocalization("email_empty_error_text");
  }
  // This is just a regular expression for email addresses
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
  RegExp regExp = new RegExp(p);

  if (regExp.hasMatch(value)) {
    // So, the email is valid
    return null;
  }

  // The pattern of the email didn't match the regex above.
  return localizations!.getLocalization("email_invalid_error_text");
}

List<Map<String, int>> recordMap = [];

var dio = Dio();

///Timer
late Timer timer;

///SharedPreferences
late SharedPreferences preferences;

///Platforms
AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosDeviceInfo;

///App Settings
String? appLogoUrl;

///URL
///// const BASE_URL = "https://masterstudy.stylemixthemes.com/academy";
// const BASE_URL = "https://masterstudy.stylemixstage.com/academy";
// const BASE_URL = "https://siip.school";
const String baseUrl = "https://ms.stylemix.biz";
const String apiEndpoint = baseUrl + "/wp-json/ms_lms/v2/";
