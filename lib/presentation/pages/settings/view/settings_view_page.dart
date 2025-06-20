import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class SettingsViewPage extends StatefulWidget {
  SettingsViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsViewPageState();
  }
}

class SettingsViewPageState extends State<SettingsViewPage> {
  String _subTitle = "";
  @override
  void initState(){
    super.initState();
    fetch();
  }
  Future<void> fetch() async{
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString("user_theme_mode");
    switch (themeString) {
      case 'light':
        _subTitle = "Light";
        break;
      case 'dark':
        _subTitle = "Dark";
        break;
      case 'system':
      default:
        _subTitle = "System";
    }
    setState(() {

    });
  }
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
          clipBehavior: Clip.antiAlias,
          child: Column(children: [

      ListTile(
        leading: Icon(Icons.brightness_6),
        title: Text("AppTheme"),
        subtitle: Text(_subTitle),
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
                fetch();
              },
            ),
            ListTile(
              title: Text('Light'),
              onTap: () {
                MyAppState? state = context.findAncestorStateOfType<MyAppState>();
                state?.changeTheme(ThemeMode.light);
                Navigator.of(context).pop();
                fetch();
              },
            ),
            ListTile(
              title: Text('Dark'),
              onTap: () {
                MyAppState? state = context.findAncestorStateOfType<MyAppState>();
                state?.changeTheme(ThemeMode.dark);
                Navigator.of(context).pop();
                fetch();
              },
            ),
          ],
        ),
      ),
    );
  }

}
