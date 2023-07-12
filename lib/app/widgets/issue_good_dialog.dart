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

  void Function(Document document, int supplierID, int quantity) onSaveRecord;

  ReceiveGoodDialog(this.document, this.quantity, this.onSaveRecord);

  @override
  State<StatefulWidget> createState() {
    return ReceiveGoodDialogState();
  }
}

class ReceiveGoodDialogState extends State<ReceiveGoodDialog> {
  final teQuantity = TextEditingController();
  final teCustomer = TextEditingController();
  final teDescription = TextEditingController();

  int customerId = -1;
  String? date;

  @override
  void initState() {
    teQuantity.text = widget.quantity.toString();
    teDescription.text = widget.document.description;
    date = DateFormat(Config.dateTimeFormat).format(widget.document.date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.issue_goods_title),
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
                dateMask: Config.dateTimeFormat,
                initialValue: date,
                firstDate: DateTime(Config.minYear),
                lastDate: DateTime(Config.maxYear),
                dateLabelText: AppLocalizations.of(context)!.field_date,
                onSaved: (val) => date = val),*/
            TextFormField(
              readOnly: true,
              controller: teCustomer,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.field_customer),
              onTap: onCustomerTapped,
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
            document.name = "";
            //document.date = (new DateFormat(Config.dateTimeFormat)).parse(date);
            document.description = teDescription.text;
            print(document);
            widget.onSaveRecord(
                document, customerId, int.parse(teQuantity.text));
          },
        ),
      ],
    );
  }

  void onCustomerTapped() async {
    /*final result = await Navigator.of(context)
        .pushNamed(Pages.customer_list, arguments: {"isSelection": true});
    if (result != null) {
      Customer customer = result;
      teCustomer.text = customer.name;
      customerId = customer.id;
    }*/
  }
}
