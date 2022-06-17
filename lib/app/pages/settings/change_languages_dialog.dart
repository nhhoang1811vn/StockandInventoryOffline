import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum EnumLanguage { ENGLISH, VIETNAMESE }

class ChangeLanguagesDialog extends StatefulWidget {
  final void Function(String code) onValueChange;
  final String code;

  ChangeLanguagesDialog(this.code, this.onValueChange);

  @override
  State<StatefulWidget> createState() {
    return ChangeLanguagesDialogState();
  }
}

class ChangeLanguagesDialogState extends State<ChangeLanguagesDialog> {
  EnumLanguage _language;

  @override
  void initState() {
    if (widget.code == "vi") {
      _language = EnumLanguage.VIETNAMESE;
    } else {
      _language = EnumLanguage.ENGLISH;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).dialog_title_change_language),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRadioListTile(EnumLanguage.ENGLISH,
                    AppLocalizations.of(context).english_text),
                getRadioListTile(EnumLanguage.VIETNAMESE,
                    AppLocalizations.of(context).vietnamese_text),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context).action_cancel),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context).action_ok),
          onPressed: () async {
            if (_language == EnumLanguage.VIETNAMESE) {
              widget.onValueChange("vi");
            } else {
              widget.onValueChange("en");
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<EnumLanguage> getRadioListTile(
      EnumLanguage value, String text) {
    return RadioListTile<EnumLanguage>(
      title: Text(text),
      value: value,
      groupValue: _language,
      onChanged: (EnumLanguage value) {
        setState(() {
          _language = value;
        });
      },
      dense: true,
    );
  }
}
