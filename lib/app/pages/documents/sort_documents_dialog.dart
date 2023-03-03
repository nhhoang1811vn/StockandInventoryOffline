import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/documents_settings.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

class SortDocumentsDialog extends StatefulWidget {
  final void Function() onValueChange;
  final DocumentSettings settings;

  SortDocumentsDialog(this.settings, this.onValueChange);

  @override
  SortDocumentsDialogState createState() => SortDocumentsDialogState();
}

class SortDocumentsDialogState extends State<SortDocumentsDialog> {
  SortByText _sortByName;
  SortByNumber _sortByDate;
  SortByNumber _sortByQuantity;

  @override
  void initState() {
    _sortByName = widget.settings.sortByName;
    _sortByDate = widget.settings.sortByDate;
    _sortByQuantity = widget.settings.sortByQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).dialog_title_sort_by),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Wrap(
              runSpacing: 0,
              children: [
                Text(AppLocalizations.of(context).field_name),
                Divider(),
                getSortByNameRadioListTile(SortByText.no_sort),
                getSortByNameRadioListTile(SortByText.a_to_z),
                getSortByNameRadioListTile(SortByText.z_to_a),
                Text(AppLocalizations.of(context).field_date),
                Divider(),
                getSortByDateRadioListTile(SortByNumber.no_sort),
                getSortByDateRadioListTile(SortByNumber.ascending),
                getSortByDateRadioListTile(SortByNumber.descending),
                Text(AppLocalizations.of(context).field_quantity),
                Divider(),
                getSortByQuantityRadioListTile(SortByNumber.no_sort),
                getSortByQuantityRadioListTile(SortByNumber.ascending),
                getSortByQuantityRadioListTile(SortByNumber.descending),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context).action_ok),
          onPressed: () async {
            widget.settings.sortByName = _sortByName;
            widget.settings.sortByDate = _sortByDate;
            widget.settings.sortByQuantity = _sortByQuantity;
            widget.onValueChange();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<SortByText> getSortByNameRadioListTile(SortByText value) {
    return RadioListTile<SortByText>(
      title: Text(
        SortByTextHelper.getText(context, value),
        style: TextStyle(fontSize: 14),
      ),
      value: value,
      groupValue: _sortByName,
      onChanged: (SortByText value) {
        setState(() {
          _sortByName = value;
        });
      },
      dense: true,
    );
  }

  RadioListTile<SortByNumber> getSortByDateRadioListTile(SortByNumber value) {
    return RadioListTile<SortByNumber>(

        title: Text(SortByNumberHelper.getText(context, value),
            style: TextStyle(fontSize: 14)),
        value: value,
        groupValue: _sortByDate,
        onChanged: (SortByNumber value) {
          setState(() {
            _sortByDate = value;
          });
        },
        dense: true);
  }

  RadioListTile<SortByNumber> getSortByQuantityRadioListTile(
      SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(SortByNumberHelper.getText(context, value),
          style: TextStyle(fontSize: 14)),
      value: value,
      groupValue: _sortByQuantity,
      onChanged: (SortByNumber value) {
        setState(() {
          _sortByQuantity = value;
        });
      },
      dense: true,
    );
  }
}
