import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

class SortGoodsDialog extends StatefulWidget {
  final void Function() onValueChange;
  final GoodsSettings settings;

  SortGoodsDialog(this.settings, this.onValueChange);

  @override
  SortGoodsDialogState createState() => SortGoodsDialogState();
}

class SortGoodsDialogState extends State<SortGoodsDialog> {
  SortByText _sortByName;
  SortByNumber _sortByBarCode;
  SortByNumber _sortByQuantity;

  @override
  void initState() {
    _sortByName = widget.settings.sortByName;
    _sortByBarCode = widget.settings.sortByBarcode;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).field_name),
                Divider(color: Colors.grey),
                getRadioListTileSortByName(SortByText.no_sort),
                getRadioListTileSortByName(SortByText.a_to_z),
                getRadioListTileSortByName(SortByText.z_to_a),
                Text(AppLocalizations.of(context).field_bar_code),
                Divider(color: Colors.grey),
                getRadioListTileSortByBarCode(SortByNumber.no_sort),
                getRadioListTileSortByBarCode(SortByNumber.ascending),
                getRadioListTileSortByBarCode(SortByNumber.descending),
                Text(AppLocalizations.of(context).field_quantity),
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
          child: Text(AppLocalizations.of(context).action_ok),
          onPressed: () async {
            widget.settings.sortByName = _sortByName;
            widget.settings.sortByBarcode = _sortByBarCode;
            widget.settings.sortByQuantity = _sortByQuantity;
            widget.onValueChange();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<SortByText> getRadioListTileSortByName(SortByText value) {
    return RadioListTile<SortByText>(
      title: Text(SortByTextHelper.getText(context, value)),
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

  RadioListTile<SortByNumber> getRadioListTileSortByBarCode(
      SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(SortByNumberHelper.getText(context, value)),
      value: value,
      groupValue: _sortByBarCode,
      onChanged: (SortByNumber value) {
        setState(() {
          _sortByBarCode = value;
        });
      },
      dense: true,
    );
  }

  RadioListTile<SortByNumber> getRadioListTileSortByQuantity(
      SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(SortByNumberHelper.getText(context, value)),
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
