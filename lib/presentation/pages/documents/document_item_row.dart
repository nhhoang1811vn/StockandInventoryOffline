import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/payment_status.dart';
import 'package:good_manager/presentation/constants.dart';

class DocumentItemRow extends StatelessWidget {
  final Document item;
  final bool showAll;
  void Function(Document document) onDocumentTapped;
  void Function(Document document) onDocumentLongPressed;

  DocumentItemRow(this.showAll, this.item, this.onDocumentTapped, this.onDocumentLongPressed);

  @override
  Widget build(BuildContext context) {
    return
      //margin: EdgeInsets.only(top: 16.0,left: 16.0, right: 16.0),
         InkWell(
          onTap: () => onDocumentTapped(item),
          onLongPress: () => onDocumentLongPressed(item)
        ,child:  Container(
          padding: EdgeInsets.fromLTRB(16, 8 , 16 , 8),
          child: Column(
            children: [
              Align(alignment: Alignment.centerRight, child: _buildPaymentStatusWidget()),
              IntrinsicHeight(
                  child: Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    color: getIndicatorColor(item.type),
                    //child: Column(),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style:
                          Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      //SizedBox(height: 4),
                      Text(Config.dateFormat.format(item.date), style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground)),
                      //SizedBox(height: 4),
                      item.personName != null ? Text(item.personName!, style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground),) : Container(),
                      item.description.isNotEmpty ? Text(item.description, style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground)) : Container()
                    ],
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.quantity.toString(), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                      Text(Config.currencyFormat.format(item.amount))
                    ],
                  )

                ],
              ))
            ],
          ),
        ));
  }

  Widget _buildPaymentStatusWidget() {
    switch (item.paymentStatus) {
      case PaymentStatus.UNPAID:
        return Icon(UIConstants.paymentIconData,size: 24, color: Palette.red);
      case PaymentStatus.PARTIAL:
        return Icon(UIConstants.paymentIconData,size: 24, color: Palette.yellow);
      case PaymentStatus.PAID:
        return Icon(UIConstants.paymentIconData,size: 24, color: Palette.green);
    }
  }

  String getTitleText(BuildContext context, DocumentType type, String name) {
    if (showAll) {
      switch (type) {
        case DocumentType.incoming:
          return "${AppLocalizations.of(context)!.incoming_document_text} $name";
        case DocumentType.outgoing:
          return "${AppLocalizations.of(context)!.outgoing_document_text} $name";
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
