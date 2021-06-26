import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';

class SortSupplierDialog extends StatefulWidget {
  final void Function() onValueChange;
  final SupplierSettings settings;

  SortSupplierDialog(this.settings, this.onValueChange);

  @override
  SortSupplierDialogState createState() => SortSupplierDialogState();
}

class SortSupplierDialogState extends State<SortSupplierDialog> {
  SortByText _sortByName;

  @override
  void initState() {
    _sortByName = widget.settings.sortByName;
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
                getRadioListTile("Không sắp xếp", SortByText.no_sort),
                getRadioListTile("Sắp xếp A-Z", SortByText.a_to_z),
                getRadioListTile("Sắp xếp Z-A", SortByText.z_to_a)
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
            widget.onValueChange();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<SortByText> getRadioListTile(String text, SortByText value) {
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
}