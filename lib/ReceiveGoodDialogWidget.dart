import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:good_manager/model/Supplier.dart';
import 'package:good_manager/suppliers/suppliers_page.dart';
import 'package:intl/intl.dart';

import 'model/Document.dart';

class ReceiveGoodDialogWidget extends StatefulWidget {
  void Function(Document document) onRetrievedADocument;
  ReceiveGoodDialogWidget(this.onRetrievedADocument);

  @override
  State<StatefulWidget> createState() {
    return ReceiveGoodDialogWidgetState();
  }
}

class ReceiveGoodDialogWidgetState extends State<ReceiveGoodDialogWidget> {
  final teDate = TextEditingController();
  final teSupplier =  TextEditingController();
  final teDescription = TextEditingController();

  int supplierId = -1;
  String supplierName = "";
  String date;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nhập hàng'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: teDate,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'dd/MM/yyyy',
              initialValue: DateFormat('dd/MM/yyyy').format(DateTime.now()),
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
            Document document = Document();
            document.name ="";
            document.date = DateTime.parse(date);
            document.description = teDescription.text;
            print(document);
            widget.onRetrievedADocument(document);
          },
        ),
      ],
    );
  }
  void onSupplierTapped() async{
    final supplier = await Navigator.of(context).pushNamed(SuppliersPageWidget.routeName, arguments: SuppliersPageArgument(true));
    Map data = (supplier as Map<String, dynamic>);
    print(data);
    if (supplier != null){
      teSupplier.text = data["name"];
      supplierId = data["id"];
    }
  }
}
