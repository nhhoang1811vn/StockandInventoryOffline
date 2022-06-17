import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/main.dart';
import 'package:good_manager/app/pages/settings/change_languages_dialog.dart';
import 'package:good_manager/data/app_data_manager.dart';

import '../pages.dart';

class SettingsController extends Controller {
  @override
  void initListeners() {}

  void showSelectLanguageDialog() async {
    String currentCode =
        await appDataManager.sharedPrefsHelper.getLanguageCode();
    showDialog(
        context: getContext(),
        builder: (_) => ChangeLanguagesDialog(currentCode, (code) {
              appDataManager.sharedPrefsHelper.setLanguageCode(code);
              MyApp.setLocale(getContext(), code);
            }),
        barrierDismissible: true);
  }

  void onBarcodeScannerPressed() async {
    Navigator.of(getContext()).pushNamed(Pages.barcode_scanner);
  }
}
