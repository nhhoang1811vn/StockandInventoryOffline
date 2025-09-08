import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import '../../widget/views.dart';
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
        title: new Text(context.tr("settings")),
      ),
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
                title: Text(context.tr("general")),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_general);
                  //showSelectLanguageDialog(context);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text(context.tr("display")),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_view);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(UIConstants.barcodeIconData),
                title: Text(
                  context.tr("menu_item_barcode_scanner"),
                ),
                onTap: () => onBarcodeScannerPressed(context),
                trailing: Icon(Icons.navigate_next),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.warning),
                title: Text(
                  context.tr("menu_item_minimum_quantity"),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(Pages.settings_minimum_quantity);
                },
                trailing: Icon(Icons.navigate_next),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.business),
                title: Text(context.tr("menu_item_my_company")),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.of(context).pushNamed(Pages.settings_my_company);
                },
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.backup),
                title: Text(
                  context.tr("menu_item_backup_and_restore"),
                ),
                onTap: () =>
                    Navigator.of(context).pushNamed(Pages.settings_data),
                trailing: Icon(Icons.navigate_next),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onBarcodeScannerPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.barcode_scanner_settings);
  }
}
