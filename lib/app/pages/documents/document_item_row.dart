import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:intl/intl.dart';

class DocumentItemRow extends StatelessWidget {
  final Document item;
  final bool showAll;
  void Function(Document document) onDocumentTapped;
  void Function(Document document) onDocumentLongPressed;

  DocumentItemRow(this.showAll, this.item, this.onDocumentTapped,
      this.onDocumentLongPressed);

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    return ListTile(
      leading: Container(
        width: 8,
        height: 200,
        color: getIndicatorColor(item.type),
      ),
      title: Transform.translate(
        offset: Offset(-32, 0),
        child: Text(getTitleText(context, item.type, item.name),
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      ),
      subtitle: Transform.translate(
        offset: Offset(-32, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ngày ' + format.format(item.date)),
          item.supplierName != null ? Text(item.supplierName) : Container(),
          item.customerName != null ? Text(item.customerName) : Container(),
          item.description.isNotEmpty ? Text(item.description) : Container()
        ]),
      ),
      trailing: Text(item.quantity.toString()),
      onTap: () => onDocumentTapped(item),
      onLongPress: () => onDocumentLongPressed(item),
    );
  }

  String getTitleText(BuildContext context, DocumentType type, String name) {
    if (showAll) {
      switch (type) {
        case DocumentType.incoming:
          return "${AppLocalizations.of(context).document_list_incoming_name} $name";
        case DocumentType.outgoing:
          return "${AppLocalizations.of(context).document_list_outgoing_name} $name";
        default:
          return "${AppLocalizations.of(context).document_list_stock_taking_name} $name";
      }
    } else {
      return name;
    }
  }

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
}
