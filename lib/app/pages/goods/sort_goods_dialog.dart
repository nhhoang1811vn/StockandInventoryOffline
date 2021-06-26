import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      title: Text('Sắp xếp'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                Text('Theo Tên'),
                Divider(color: Colors.grey),
                getRadioListTileSortByName("Không sắp xếp", SortByText.no_sort),
                getRadioListTileSortByName("Sắp xếp A-Z", SortByText.a_to_z),
                getRadioListTileSortByName("Sắp xếp Z-A", SortByText.z_to_a),
                Text('Theo Bar Code'),
                Divider(color: Colors.grey),
                getRadioListTileSortByBarCode(
                    "Không sắp xếp", SortByNumber.no_sort),
                getRadioListTileSortByBarCode(
                    "Tăng dần", SortByNumber.ascending),
                getRadioListTileSortByBarCode(
                    "Giảm dần", SortByNumber.descending),
                Text('Theo Quantity'),
                Divider(color: Colors.grey),
                getRadioListTileSortByQuantity(
                    "Không sắp xếp", SortByNumber.no_sort),
                getRadioListTileSortByQuantity(
                    "Tăng dần", SortByNumber.ascending),
                getRadioListTileSortByQuantity(
                    "Giảm dần", SortByNumber.descending),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
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

  RadioListTile<SortByText> getRadioListTileSortByName(
      String text, SortByText value) {
    return RadioListTile<SortByText>(
      title: Text(text),
      value: value,
      groupValue: _sortByName,
      onChanged: (SortByText value) {
        setState(() {
          _sortByName = value;
        });
      },
    );
  }

  RadioListTile<SortByNumber> getRadioListTileSortByBarCode(
      String text, SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(text),
      value: value,
      groupValue: _sortByBarCode,
      onChanged: (SortByNumber value) {
        setState(() {
          _sortByBarCode = value;
        });
      },
    );
  }

  RadioListTile<SortByNumber> getRadioListTileSortByQuantity(
      String text, SortByNumber value) {
    return RadioListTile<SortByNumber>(
      title: Text(text),
      value: value,
      groupValue: _sortByQuantity,
      onChanged: (SortByNumber value) {
        setState(() {
          _sortByQuantity = value;
        });
      },
    );
  }
}
