import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/payment_status.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';

class DocumentItemRow2 extends StatelessWidget {
  final Document item;
  final bool showAll;
  final void Function(Document document) onDocumentTapped;
  final void Function(Document document) onDocumentLongPressed;

  DocumentItemRow2(this.showAll, this.item, this.onDocumentTapped, this.onDocumentLongPressed);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onDocumentTapped(item),
          onLongPress: () => onDocumentLongPressed(item),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getIndicatorColor(item.type), // Change color as needed
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Padding(padding: EdgeInsets.all(16), child: Row(children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          //SizedBox(height: 4),
                          Text(Config.dateFormat.format(item.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
                          //SizedBox(height: 4),
                          item.personName != null
                              ? Text(
                            item.personName!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onSurface),
                          )
                              : Container(),
                          item.description.isNotEmpty
                              ? Text(item.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Theme.of(context).colorScheme.onSurface))
                              : Container()
                        ],
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Utils.getQuantityText(item.quantity), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                      Text(Config.currencyFormat.format(item.amount))
                    ],
                  )
                ],),))
              ],
            ),
          )),
    );
  }

  String getTitleText(BuildContext context, DocumentType type, String name) {
    if (showAll) {
      switch (type) {
        case DocumentType.incoming:
          return "${AppLocalizations.of(context)!.incoming_document_text} $name";
        default:
          return "${AppLocalizations.of(context)!.outgoing_document_text} $name";
      }
    } else {
      return name;
    }
  }

  Color getIndicatorColor(DocumentType type) {
    switch (type) {
      case DocumentType.incoming:
        return Colors.red;
    default:
        return Colors.green;
    }
  }
}
