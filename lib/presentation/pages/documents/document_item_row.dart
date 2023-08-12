import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';

class DocumentItemRow extends StatelessWidget {
  final Document item;
  final bool showAll;
  void Function(Document document) onDocumentTapped;
  void Function(Document document) onDocumentLongPressed;

  DocumentItemRow(this.showAll, this.item, this.onDocumentTapped,
      this.onDocumentLongPressed);

  @override
  Widget build(BuildContext context) {
    //DateFormat format = DateFormat("dd/MM/yyyy");
    return ListTile(
      leading: Container(
        width: 8,
        height: 200,
        color: getIndicatorColor(item.type),
      ),
      title: Transform.translate(
        offset: Offset(-32, 0),
        child: Text(getTitleText(context, item.type, item.name),
            style: AppStyle.getTitleListTitleStyle()),
      ),
      subtitle: Transform.translate(
        offset: Offset(-32, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Config.dateFormat.format(item.date), style: AppStyle.getSubTitleListTitleStyle()),
          item.personName != null ? Text(item.personName!, style: AppStyle.getSubTitleListTitleStyle(),) : Container(),
          item.description.isNotEmpty ? Text(item.description, style: AppStyle.getSubTitleListTitleStyle()) : Container()
        ]),
      ),
      trailing: Text(item.quantity.toString(), style: AppStyle.getTrailingListTitleStyle()),
      onTap: () => onDocumentTapped(item),
      onLongPress: () => onDocumentLongPressed(item),
    );
  }

  String getTitleText(BuildContext context, DocumentType type, String name) {
    if (showAll) {
      switch (type) {
        case DocumentType.incoming:
          return "${AppLocalizations.of(context)!.document_list_incoming_name} $name";
        case DocumentType.outgoing:
          return "${AppLocalizations.of(context)!.document_list_outgoing_name} $name";
        default:
          return "";
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
