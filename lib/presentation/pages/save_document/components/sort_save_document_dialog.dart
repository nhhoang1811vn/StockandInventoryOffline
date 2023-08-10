import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/save_document_setting.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

class SortSaveDocumentDialog extends StatefulWidget {
  final SaveDocumentSetting setting;

  SortSaveDocumentDialog(this.setting);

  @override
  SortSaveDocumentDialogState createState() => SortSaveDocumentDialogState();
}

class SortSaveDocumentDialogState extends State<SortSaveDocumentDialog> {
  late SortByText _sortByName;
  late SortByNumber _sortByBarCode;
  late SortByNumber _sortByQuantity;
  @override
  void initState() {
    _sortByName = widget.setting.sortByName;
    _sortByBarCode = widget.setting.sortByBarcode;
    _sortByQuantity = widget.setting.sortByQuantity;
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
                getRadioListTileSortByName(SortByText.no_sort),
                getRadioListTileSortByName(SortByText.a_to_z),
                getRadioListTileSortByName(SortByText.z_to_a),
                Text(AppLocalizations.of(context)!.field_bar_code),
                Divider(color: Colors.grey),
                getRadioListTileSortByBarCode(SortByNumber.no_sort),
                getRadioListTileSortByBarCode(SortByNumber.ascending),
                getRadioListTileSortByBarCode(SortByNumber.descending),
                Text(AppLocalizations.of(context)!.field_quantity),
                Divider(color: Colors.grey),
                getRadioListTileSortByQuantity(SortByNumber.no_sort),
                getRadioListTileSortByQuantity(SortByNumber.ascending),
                getRadioListTileSortByQuantity(SortByNumber.descending),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            SaveDocumentSetting setting = widget.setting.copyWith(
                sortByName: _sortByName,
                sortByBarcode: _sortByBarCode,
                sortByQuantity: _sortByQuantity,
            );
            Navigator.of(context).pop(setting);
          },
        ),
      ],
    );
  }

  RadioListTile<SortByText> getRadioListTileSortByName(SortByText value) {
    return RadioListTile<SortByText>(
      title: Text(value.getText(context)),
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

  RadioListTile<SortByNumber> getRadioListTileSortByBarCode(
      SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(value.getText(context)),
      value: value,
      groupValue: _sortByBarCode,
      onChanged: (SortByNumber? value) {
        setState(() {
          _sortByBarCode = value!;
        });
      },
      dense: true,
    );
  }

  RadioListTile<SortByNumber> getRadioListTileSortByQuantity(
      SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(value.getText(context)),
      value: value,
      groupValue: _sortByQuantity,
      onChanged: (SortByNumber? value) {
        setState(() {
          _sortByQuantity = value!;
        });
      },
      dense: true,
    );
  }
}
