import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  GoogleSignIn googleSignIn = GoogleSignIn();

  void initializeGoogleSignIn() {
    googleSignIn = GoogleSignIn();
  }

  Future<GoogleSignInAccount> signInGoogle() async {
    try {
      return await googleSignIn.signIn().then((value) async {
        var ggAuth = await value!;
        return ggAuth;
      });
    } catch (error) {
      log("Google Sign In Error: $error");
      throw Exception();
    }
  }

  Future logoutGoogle() async {
    try {
      googleSignIn.disconnect();
    } catch (error) {
      log("Google Logout Error: $error");
    }
  }
}
