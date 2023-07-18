import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/expenses_setting.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';

class SortExpensesDialog extends StatefulWidget {
  final ExpensesSetting settings;

  SortExpensesDialog(this.settings);

  @override
  SortExpensesDialogState createState() => SortExpensesDialogState();
}

class SortExpensesDialogState extends State<SortExpensesDialog> {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.field_date),
                Divider(color: Colors.grey),
                getRadioListTileSortByDate(SortByNumber.no_sort),
                getRadioListTileSortByDate(SortByNumber.ascending),
                getRadioListTileSortByDate(SortByNumber.descending),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            ExpensesSetting result = widget.settings.copyWith(sortByDate: _sortByDate);
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }

  RadioListTile<SortByNumber> getRadioListTileSortByDate(SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(value.getText(context)),
      value: value,
      groupValue: _sortByDate,
      onChanged: (SortByNumber? value) {
        setState(() {
          _sortByDate = value!;
        });
      },
      dense: true,
    );
  }
}
