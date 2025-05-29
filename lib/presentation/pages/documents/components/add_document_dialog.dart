import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';

class AddDocumentDialogWidget extends StatefulWidget {
  @override
  State createState() => AddDocumentDialogWidgetState();
}
class AddDocumentDialogWidgetState extends State<AddDocumentDialogWidget> {
  DocumentType _documentType = DocumentType.incoming;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.add_document_title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                getRadioListTile(
                    AppLocalizations.of(context)!.incoming_document_text,
                    DocumentType.incoming),
                getRadioListTile(
                    AppLocalizations.of(context)!.outgoing_document_text,
                    DocumentType.outgoing),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            //widget.onValueChange(_documentType);
            Navigator.of(context).pop(_documentType);
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
      onChanged: (DocumentType? value) {
        setState(() {
          _documentType = value!;
        });
      },
    );
  }
}
