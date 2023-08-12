import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';

import '../../style_size.dart';

class SortDocumentsDialog extends StatefulWidget {
  final DocumentsSetting settings;

  SortDocumentsDialog(this.settings);

  @override
  SortDocumentsDialogState createState() => SortDocumentsDialogState();
}

class SortDocumentsDialogState extends State<SortDocumentsDialog> {
  late SortByNumber _sortByDate;
  @override
  void initState() {
    _sortByDate = widget.settings.sortByDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.dialog_title_sort_by),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Wrap(
              runSpacing: 0,
              children: [
                Text(AppLocalizations.of(context)!.field_date),
                Divider(),
                getSortByDateRadioListTile(SortByNumber.no_sort),
                getSortByDateRadioListTile(SortByNumber.ascending),
                getSortByDateRadioListTile(SortByNumber.descending),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            DocumentsSetting result = widget.settings.copyWith(sortByDate: _sortByDate);
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }

  RadioListTile<SortByNumber> getSortByDateRadioListTile(SortByNumber value) {
    return RadioListTile<SortByNumber>(
        title: Text(value.getText(context),
            style: TextStyle(fontSize: TextSize.medium)),
        value: value,
        groupValue: _sortByDate,
        onChanged: (SortByNumber? value) {
          setState(() {
            _sortByDate = value!;
          });
        },
        dense: true);
  }
}
