import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:intl/intl.dart';

class DocumentList extends StatelessWidget{
  List<Document> items;
  bool showAll = false;
  void Function(Document document) onDocumentTapped;
  void Function(Document document) onDocumentLongPressed;

  DocumentList(this.items, this.onDocumentTapped, this.onDocumentLongPressed,
      this.showAll);

  Color getIndicatorColor(DocumentType type) {
    switch (type) {
      case DocumentType.incoming:
        return Colors.red;
      case DocumentType.outgoing:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  String getTitleText(BuildContext context, DocumentType type, String name) {
    if (showAll) {
      switch (type) {
        case DocumentType.incoming:
          return "${AppLocalizations.of(context)!.document_list_incoming_name} $name";
        case DocumentType.outgoing:
          return "${AppLocalizations.of(context)!.document_list_outgoing_name} $name";
        }
    } else {
      return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("dd/MM/yyyy", "vi");
    if (items == null || items.isEmpty) {
      return Center(
        child: Text('Không có giao dịch'),
      );
    } else {
      return new ListView.separated(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Container(width: 8,height: 200,color: getIndicatorColor(items[index].type),),
            title: Transform.translate(
              offset: Offset(-32, 0),
              child: Text(
                  getTitleText(context, items[index].type, items[index].name),
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
            subtitle: Transform.translate(
              offset: Offset(-32, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text('Ngày ' + format.format(items[index].date)),
                    items[index].supplierName != null
                        ? Text(items[index].supplierName!)
                        : Container(),
                    items[index].description.isNotEmpty
                        ? Text(items[index].description)
                        : Container()
                  ]),
            ),
            trailing: Text(items[index].quantity.toString()),
            onTap: () => onDocumentTapped(items[index]),
            onLongPress: () => onDocumentLongPressed(items[index]),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },


      );
    }
  }
}