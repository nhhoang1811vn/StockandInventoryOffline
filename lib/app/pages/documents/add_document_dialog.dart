import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/document.dart';


class AddDocumentDialogWidget extends StatefulWidget {
  final void Function(DocumentType type) onValueChange;

  AddDocumentDialogWidget(this.onValueChange, {Key key}) : super(key: key);

  @override
  State createState() => AddDocumentDialogWidgetState();
}

class AddDocumentDialogWidgetState extends State<AddDocumentDialogWidget> {
  DocumentType _documentType = DocumentType.incoming;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm giao dịch'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                getRadioListTile("Nhập Kho", DocumentType.incoming),
                getRadioListTile("Xuất Kho", DocumentType.outgoing),
                //getRadioListTile("Kiểm kê", DocumentType.stock_taking)
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () async {
            //final prefs = await SharedPreferences.getInstance();
            //prefs.setString(Constants.KEY_SORT_BY_STORE, EnumToString.convertToString(_sortByName));
            widget.onValueChange(_documentType);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<DocumentType> getRadioListTile(
      String text, DocumentType value) {
    return RadioListTile<DocumentType>(
      title: Text(text),
      value: value,
      groupValue: _documentType,
      onChanged: (DocumentType value) {
        setState(() {
          _documentType = value;
        });
      },
    );
  }
}
