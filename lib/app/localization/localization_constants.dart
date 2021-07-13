import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LANGUAGE_CODE = "LANGUAGE_CODE";
const String ENGLISH = "en";
const String VIETNAMESE = "vi";

Locale locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale("en", "US");
      break;
    case VIETNAMESE:
      _temp = Locale("vi", "VN");
  }
  return _temp;
}

Future<Locale> getLocale() async {
  String deviceLanguageCode = Platform.localeName;
  String defaultLanguageCode = ENGLISH;
  if (deviceLanguageCode == "vi_VN") {
    defaultLanguageCode = VIETNAMESE;
  } else {
    defaultLanguageCode = ENGLISH;
  }
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? defaultLanguageCode;
  return locale(languageCode);
}

Future<void> setLocale(String code) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString(LANGUAGE_CODE, code);
}
