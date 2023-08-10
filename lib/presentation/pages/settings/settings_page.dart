import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/main.dart';

import '../custom_navigation_drawer.dart';
import '../pages.dart';
import 'components/change_languages_dialog.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomNavigationDrawer(selectedIndex: 8, storeName: storage.getSelectedStoreName()),
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context)!.settings_title)),
        body: ListView(
          //key: globalKey,
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title:
              Text(AppLocalizations.of(context)!.menu_item_language_title),
              subtitle:
              Text(AppLocalizations.of(context)!.menu_item_language_desc),
              onTap: (){ showSelectLanguageDialog(context);},
            )
            ,
            ListTile(
              leading: Icon(Icons.language),
              title: Text(
                  AppLocalizations.of(context)!.menu_item_barcode_scanner_title),
              onTap: () => onBarcodeScannerPressed(context),
            )

          ],
        ));
  }
  void showSelectLanguageDialog(BuildContext context) async {
    String currentCode = storage.getLanguageCode();
    showDialog(
        context: context,
        builder: (_) => ChangeLanguagesDialog(currentCode, (code) {
          storage.setLanguageCode(code);
          MyApp.setLocale(context, code);
              //appDataManager.sharedPrefsHelper.setLanguageCode(code);
              //MyApp.setLocale(getContext(), code);
            }),
        barrierDismissible: true);
  }
  void onBarcodeScannerPressed(BuildContext context){
    Navigator.of(context).pushNamed(Pages.barcode_scanner);
  }
}
