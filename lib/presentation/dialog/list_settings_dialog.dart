import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
      title: Text(context.tr("list_settings")),
      contentPadding: EdgeInsets.all(8),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            SwitchListTile(
              title: Text(
                context.tr("good_settings_hide_zero_entries"),
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
                context.tr("good_setting_show_bar_code"),
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
                context.tr("good_setting_show_description"),
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
          child: Text(context.tr("ok")),
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
