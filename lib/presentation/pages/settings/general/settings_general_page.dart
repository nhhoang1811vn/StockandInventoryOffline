import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/settings/general/bloc/settings_general_cubit.dart';

import '../../../../main.dart';
import '../components/change_languages_dialog.dart';

class SettingsGeneralPage extends StatefulWidget {
  SettingsGeneralPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsGeneralPageState();
  }
}
class SettingsGeneralPageState extends State<SettingsGeneralPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsGeneralCubit, SettingsGeneralState>(
        listener: (context, state) async {
        }, builder: (BuildContext context, SettingsGeneralState state) {
      return Scaffold(
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context)!.menu_item_general)),
        body: _buildBody(state),
      );
    });
  }

  Widget _buildBody(SettingsGeneralState state) {
    return ListView(padding: EdgeInsets.all(16), children: [
      Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: [

            ListTile(
              leading: Icon(FontAwesomeIcons.language),
              title: Text(
                  AppLocalizations.of(context)!.menu_item_language_title),
              subtitle:
              Text(AppLocalizations.of(context)!.menu_item_language_desc),
              onTap: () {
                showSelectLanguageDialog(context);
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.lock),
              title: Text(
                  AppLocalizations.of(context)!.menu_item_passcode_title),
              subtitle:
              Text(AppLocalizations.of(context)!.menu_item_passcode_title),
              trailing: Switch(

                  value: state.enablePasscode,
                  onChanged: (value) {
                    _handlePasscodeToggle(context, value, state.passcode);
                  }),
              onTap: () {
                _handlePasscodeToggle(context, !state.enablePasscode, state.passcode);
              },
            ),
    ]))]);
  }
  void showSelectLanguageDialog(BuildContext context) async {
    String currentCode = storage.getLanguageCode();
    showDialog(
        context: context,
        builder: (_) => ChangeLanguagesDialog(currentCode, (code) {
          storage.setLanguageCode(code);
          MyApp.setLocale(context, code);
        }),
        barrierDismissible: true);
  }
  void _handlePasscodeToggle(BuildContext context, bool newValue, String currentPasscode) {
    if (newValue) {
      // Turning ON passcode
      screenLockCreate(
        context: context,
        //title: Text("abc"),
        onConfirmed: (passcode) {
          Navigator.pop(context);
          context
              .read<SettingsGeneralCubit>()
              .onEnablePasscodeChanged(newValue, passcode);
        },
      );
    } else {
      // Turning OFF passcode — confirm unlock first
      screenLock(
        context: context,
        correctString: currentPasscode, // ideally use stored passcode here
        canCancel: true,
        onUnlocked: () {
          Navigator.pop(context);
          context.read<SettingsGeneralCubit>().onEnablePasscodeChanged(newValue, "");
        },
      );
    }
  }


}
