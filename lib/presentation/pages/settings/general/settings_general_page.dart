import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/settings/general/bloc/settings_general_cubit.dart';
import 'package:good_manager/presentation/pages/settings/general/language_model.dart';

import '../../../../app.dart';
import '../../../../data/app_settings.dart';
import '../../../../util/util.dart';
import '../../../widget/views.dart';

class SettingsGeneralPage extends StatefulWidget {
  SettingsGeneralPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsGeneralPageState();
  }
}

class SettingsGeneralPageState extends State<SettingsGeneralPage> {
  late String _code;

  @override
  void initState() {
    super.initState();
    _code = AppSettings.getLanguageCode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsGeneralCubit, SettingsGeneralState>(
      listener: (context, state) async {},
      builder: (BuildContext context, SettingsGeneralState state) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text(AppLocalizations.of(context)!.menu_item_general),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(SettingsGeneralState state) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.language_outlined),
                title: Text(
                  AppLocalizations.of(context)!.menu_item_language_title,
                ),
                subtitle: Text(
                  _code == "vi"
                      ? AppLocalizations.of(context)!.vietnamese_text
                      : AppLocalizations.of(context)!.english_text,
                ),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text(
                  AppLocalizations.of(context)!.menu_item_passcode_title,
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.menu_item_passcode_title,
                ),
                trailing: Switch(
                  value: state.enablePasscode,
                  onChanged: (value) {
                    _handlePasscodeToggle(context, value, state.passcode);
                  },
                ),
                onTap: () {
                  _handlePasscodeToggle(
                    context,
                    !state.enablePasscode,
                    state.passcode,
                  );
                },
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.refresh_outlined),
                title: Text(
                  AppLocalizations.of(context)!
                      .menu_item_reset_numeration_documents_title,
                ),
                onTap: () {
                  context.read<SettingsGeneralCubit>().resetAutoDocumentNo();
                  //storage.resetAutoDocumentNo(storage.getSelectedStoreId());
                  ToastUtils.showInfoToast(
                    AppLocalizations.of(context)!.success,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    List<LanguageModel> languages = [
      LanguageModel("en", "English"), // English
      LanguageModel("es", "Español"), // Spanish
      LanguageModel("zh", "简体中文"), // Chinese (Simplified)
      LanguageModel("hi", "हिन्दी"), // Hindi
      LanguageModel("ar", "العربية"), // Arabic
      LanguageModel("pt", "Português"), // Portuguese
      LanguageModel("ru", "Русский"), // Russian
      LanguageModel("ja", "日本語"), // Japanese
      LanguageModel("de", "Deutsch"), // German
      LanguageModel("fr", "Français"), // French
      LanguageModel("vi", "Tiếng Việt"), // Vietnamese (optional local addition)
    ];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.dialog_title_change_language),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return ListTile(
                title: Text(language.name), // Native name
                onTap: () {
                  MyAppState? state =
                      context.findAncestorStateOfType<MyAppState>();
                  state?.changeLanguage(language.code);
                  AppSettings.setLanguageCode(language.code);
                  Navigator.of(context).pop();
                  setState(() {
                    _code = language.code;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handlePasscodeToggle(
    BuildContext context,
    bool newValue,
    String currentPasscode,
  ) {
    if (newValue) {
      // Turning ON passcode
      screenLockCreate(
        context: context,
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
          context
              .read<SettingsGeneralCubit>()
              .onEnablePasscodeChanged(newValue, "");
        },
      );
    }
  }
}
