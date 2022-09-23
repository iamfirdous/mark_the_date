import 'dart:io';

import 'package:flutter/material.dart';

class Fonts {
  static const String Nunito = 'Nunito';
}

class Texts {
  static const String app_name = 'Mark The Date';
  static const String sign_in_title = 'Sign in with your Google account and give access to your calendar.';
  static const String note = 'Note:';
  static const String safety_note = 'We do not share your data with anyone, and it’s safe to use this app.';
  static const String app_desc =
      'Sync-up and add events, appoinments, meetings to your google calendar.';
  static const String sign_in = 'Sign in with Google';
  static const String google_signin_failed = 'Google signin failed';
}

class Images {
  static const String path = 'assets/images/';
  static const String png = '.png';
  static const String logo = '${path}logo$png';
  static const String date_illustration = '${path}date_illustration$png';
  static const String google_logo = '${path}google_logo$png';
}

class AppColors {
  static const Color primary = Color(0xFF06D4C8);
  static const Color secondary = Color(0xFF445554);
}

mixin Secret {
  static const ANDROID_CLIENT_ID =
      '994664589232-d7bvhr4h11uqvfobfp8vil71dmm3sf8g.apps.googleusercontent.com';
  static const IOS_CLIENT_ID =
      '994664589232-f0fuga6n5l3iut25j3l6j2r0mq78p3ge.apps.googleusercontent.com';
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}

class PrefKeys {
  static const String access_token = 'access_token';
}
