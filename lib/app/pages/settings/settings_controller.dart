import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/localization/localization_constants.dart';
import 'package:good_manager/app/main.dart';
import 'package:good_manager/app/pages/settings/change_languages_dialog.dart';

class SettingsController extends Controller {
  @override
  void initListeners() {}

  void showSelectLanguageDialog() async {
    Locale currentLocale = await getLocale();
    showDialog(
        context: getContext(),
        builder: (_) =>
            ChangeLanguagesDialog(currentLocale.languageCode, (code) {
              setLocale(code);
              MyApp.setLocale(getContext(), locale(code));
            }),
        barrierDismissible: true);
  }
}
