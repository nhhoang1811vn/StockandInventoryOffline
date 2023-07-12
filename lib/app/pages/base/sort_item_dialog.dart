import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

class SortItemDialog extends StatefulWidget {
  final void Function() onValueChange;
  final BaseSettings settings;

  SortItemDialog(this.settings, this.onValueChange);

  @override
  SortItemDialogState createState() => SortItemDialogState();
}

class SortItemDialogState extends State<SortItemDialog> {
  late SortByText _sortByName;

  @override
  void initState() {
    _sortByName = widget.settings.sortByName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.dialog_title_sort_by),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.field_name),
                Divider(color: Colors.grey),
                getRadioListTile(SortByText.no_sort),
                getRadioListTile(SortByText.a_to_z),
                getRadioListTile(SortByText.z_to_a)
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            widget.settings.sortByName = _sortByName;
            widget.onValueChange();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<SortByText> getRadioListTile(SortByText value) {
    return RadioListTile<SortByText>(
      title: Text(value.getText(context), style: TextStyle(fontSize: 14)),
      value: value,
      groupValue: _sortByName,
      onChanged: (SortByText? value) {
        setState(() {
          _sortByName = value!;
        });
      },
      dense: true,
    );
  }
}