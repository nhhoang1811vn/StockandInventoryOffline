//import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:intl/intl.dart';

class ReceiveGoodDialog extends StatefulWidget {
  final Document document;
  final int quantity;

  void Function(Document document, int quantity) onSaveRecord;

  ReceiveGoodDialog(this.document, this.quantity, this.onSaveRecord);

  @override
  State<StatefulWidget> createState() {
    return ReceiveGoodDialogState();
  }
}

class ReceiveGoodDialogState extends State<ReceiveGoodDialog> {
  final teQuantity = TextEditingController();
  final teSupplier = TextEditingController();
  final teDescription = TextEditingController();

  int? supplierId;
  String? date;
  String? initDate;

  @override
  void initState() {
    teQuantity.text = widget.quantity.toString();
    teDescription.text = widget.document.description;
    date = DateFormat(Config.dateTimeFormat).format(widget.document.date);
    initDate = DateFormat(Config.displayDateTimeFormat).format(widget.document.date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.receive_goods_title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: teQuantity,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.field_quantity),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            /*DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: Config.displayDateTimeFormat,
                initialValue: initDate,
                firstDate: DateTime(Config.minYear),
                lastDate: DateTime(Config.maxYear),
                dateLabelText: AppLocalizations.of(context)!.field_date,
                onChanged: (val) => date = val),*/
            TextFormField(
              readOnly: true,
              controller: teSupplier,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.field_supplier),
              onTap: onSupplierTapped,
            ),
            TextFormField(
              controller: teDescription,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.field_desc),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () {
            Document document = widget.document.clone();
            //document.date = (new DateFormat(Config.dateTimeFormat)).parse(date);
            document.description = teDescription.text;
            document.supplierId = supplierId;
            Navigator.of(context).pop();
            widget.onSaveRecord(document, int.parse(teQuantity.text));

          },
        ),
      ],
    );
  }

  void onSupplierTapped() async {
    /*final result = await Navigator.of(context)
        .pushNamed(Pages.supplier_list, arguments: {"isSelection": true});
    if (result != null) {
      Supplier supplier = result;
      teSupplier.text = supplier.name;
      supplierId = supplier.id;
    }*/
  }
}
