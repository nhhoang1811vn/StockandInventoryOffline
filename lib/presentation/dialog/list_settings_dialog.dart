import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';

import '../../domain/entity/entity.dart';

class ListSettingsDialog extends StatefulWidget {
  final GoodsSetting settings;

  ListSettingsDialog(this.settings);

  @override
  State<StatefulWidget> createState() {
    return ListSettingsDialogState();
  }
}

class ListSettingsDialogState extends State<ListSettingsDialog> {
  late bool _hideZeroEntries;
  late bool _showBarcode;
  late bool _showDescription;

  @override
  void initState() {
    super.initState();
    _hideZeroEntries = widget.settings.hideZeroEntries;
    _showBarcode = widget.settings.showBarcode;
    _showDescription = widget.settings.showDescription;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.list_settings),
      contentPadding: EdgeInsets.all(8),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context)!.good_settings_hide_zero_entries,
              ),
              value: _hideZeroEntries,
              onChanged: (value) {
                setState(() {
                  _hideZeroEntries = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context)!.good_setting_show_bar_code,
              ),
              value: _showBarcode,
              onChanged: (value) {
                setState(() {
                  _showBarcode = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context)!.good_setting_show_description,
              ),
              value: _showDescription,
              onChanged: (value) {
                setState(() {
                  _showDescription = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            GoodsSetting result = widget.settings.copyWith(
              hideZeroEntries: _hideZeroEntries,
              showBarcode: _showBarcode,
              showDescription: _showDescription,
            );
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
}
