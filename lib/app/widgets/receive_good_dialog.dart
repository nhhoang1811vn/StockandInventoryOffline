import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:intl/intl.dart';

import '../pages/pages.dart';


class ReceiveGoodDialog extends StatefulWidget {
  final Document document;
  final int quantity;

  void Function(Document document, int supplierID, int quantity) onSaveRecord;
  ReceiveGoodDialog(this.document, this.quantity,this.onSaveRecord);

  @override
  State<StatefulWidget> createState() {
    return ReceiveGoodDialogState();
  }
}

class ReceiveGoodDialogState extends State<ReceiveGoodDialog> {
  final teQuantity = TextEditingController();
  final teSupplier =  TextEditingController();
  final teDescription = TextEditingController();

  int? supplierId;
  String supplierName = "";
  String date;
  @override
  void initState() {
    teQuantity.text = widget.quantity.toString();
    teDescription.text = widget.document.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nhập hàng'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: teQuantity,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'dd/MM/yyyy',
              initialValue: DateFormat('dd/MM/yyyy').format(widget.document.date),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Ngày tạo bản ghi',
              onSaved: (val) => setState(() => date = val),
            ),
             TextFormField(
              controller: teSupplier,
              //initialValue: supplierName,
              decoration: InputDecoration(labelText: 'Nhà cung cấp'),
              onTap: onSupplierTapped,
            ),
            
            TextFormField(
              controller: teDescription,
              decoration: InputDecoration(labelText: 'Mô tả'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Document document = widget.document.clone();
            document.name ="";
            document.date = DateTime.parse(date);
            document.description = teDescription.text;
            print(document);
            widget.onSaveRecord(document, supplierId, int.parse(teQuantity.text));
          },
        ),
      ],
    );
  }
  void onSupplierTapped() async{
    final result = await Navigator.of(context)
        .pushNamed(Pages.supplier_list, arguments: {"isSelection": true});
    if (result != null) {
      Supplier supplier = result;
      teSupplier.text = supplier.name;
      supplierId = supplier.id;
    }
  }
}
