import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customers_setting.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

import '../../../style_size.dart';

class SortCustomerDialog extends StatefulWidget {
  final CustomersSetting settings;
  SortCustomerDialog(this.settings);

  @override
  SortCustomerDialogState createState() => SortCustomerDialogState();
}

class SortCustomerDialogState extends State<SortCustomerDialog> {
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
            CustomersSetting settings = widget.settings.copyWith(sortByName: _sortByName);
            Navigator.of(context).pop(settings);
          },
        ),
      ],
    );
  }

  RadioListTile<SortByText> getRadioListTile(SortByText value) {
    return RadioListTile<SortByText>(
      title: Text(value.getText(context), style: TextStyle(fontSize: TextSize.medium)),
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