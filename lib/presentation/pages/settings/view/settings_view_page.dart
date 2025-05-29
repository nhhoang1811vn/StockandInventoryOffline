import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';

import '../../../../main.dart';

class SettingsViewPage extends StatefulWidget {
  SettingsViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsViewPageState();
  }
}

class SettingsViewPageState extends State<SettingsViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text(AppLocalizations.of(context)!.menu_item_view)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(padding: EdgeInsets.all(16), children: [
      Card(
          child: Column(children: [
      SizedBox(
        height: 4,
      ),
      ListTile(
        leading: Icon(Icons.brightness_6),
        title: Text(
            "AppTheme"),
        onTap: () => _showThemeDialog(context),
        trailing: Icon(Icons.navigate_next),
      ),

    ]))]);
  }
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('System'),
              onTap: () {
                MyAppState? state = context.findAncestorStateOfType<MyAppState>();
                state?.changeTheme(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Light'),
              onTap: () {
                MyAppState? state = context.findAncestorStateOfType<MyAppState>();
                state?.changeTheme(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Dark'),
              onTap: () {
                MyAppState? state = context.findAncestorStateOfType<MyAppState>();
                state?.changeTheme(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

}
