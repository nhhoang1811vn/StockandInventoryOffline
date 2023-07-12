import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base/base_page.dart';
import 'package:good_manager/app/pages/settings/bloc/settings_data.dart';

import '../custom_navigation_drawer.dart';
import 'bloc/settings_cubit.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends BasePageState<SettingsPage, SettingsCubit, SettingsData> {
  @override
  Widget buildPage(BuildContext context, SettingsData data) {
    return Scaffold(
        drawer: const CustomNavigationDrawer(selectedIndex: 8),
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
                    onTap: cubit.showSelectLanguageDialog,
                  )
                ,
            ListTile(
                    leading: Icon(Icons.language),
                    title: Text(
                        AppLocalizations.of(context)!.menu_item_barcode_scanner_title),
                    onTap: cubit.onBarcodeScannerPressed,
                  )

          ],
        ));
  }
}
