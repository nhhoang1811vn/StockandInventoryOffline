import 'package:flutter/material.dart';
//import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';

import '../pages.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context)!.settings_title)),
        body: _buildBody(),
      );
  }


  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                    AppLocalizations.of(context)!.menu_item_general),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_general);
                  //showSelectLanguageDialog(context);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text(
                    AppLocalizations.of(context)!.menu_item_view),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_view);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(UIConstants.barcodeIconData),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_barcode_scanner),
                onTap: () => onBarcodeScannerPressed(context),
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.warning),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_minimum_quantity),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_minimum_quantity);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.business),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_my_company),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.of(context).pushNamed(Pages.settings_my_company);
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.backup),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_backup_and_restore),
                onTap: () => Navigator.of(context).pushNamed(Pages.settings_data),
                trailing: Icon(Icons.navigate_next),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void onBarcodeScannerPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.barcode_scanner);
  }
}
