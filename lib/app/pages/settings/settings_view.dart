import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../custom_navigation_drawer.dart';
import 'settings_controller.dart';

class SettingsPage extends View {
  SettingsPage({Key key}) : super(key: key);

  @override
  SettingsPageView createState() => SettingsPageView();
}

class SettingsPageView extends ViewState<SettingsPage, SettingsController> {
  SettingsPageView() : super(SettingsController());

  @override
  Widget get view => Scaffold(
      drawer: const CustomNavigationDrawer(selectedIndex: 8),
      appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).settings_title)),
      body: ListView(
        key: globalKey,
        children: [
          ControlledWidgetBuilder<SettingsController>(
              builder: (context, controller) {
            return ListTile(
              leading: Icon(Icons.language),
              title:
                  Text(AppLocalizations.of(context).menu_item_language_title),
              subtitle:
                  Text(AppLocalizations.of(context).menu_item_language_desc),
              onTap: controller.showSelectLanguageDialog,
            );
          }),
          ControlledWidgetBuilder<SettingsController>(
              builder: (context, controller) {
            return ListTile(
              leading: Icon(Icons.language),
              title: Text(
                  AppLocalizations.of(context).menu_item_barcode_scanner_title),
              onTap: controller.onBarcodeScannerPressed,
            );
          })
        ],
      ));
}
