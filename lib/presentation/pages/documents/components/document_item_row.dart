import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';

class DocumentItemRow extends StatelessWidget {
  final Document item;
  final Color bgColor;
  //final bool showAll;
  final void Function(Document document) onDocumentTapped;
  final void Function(Document document) onDocumentLongPressed;

  DocumentItemRow(
      //this.showAll
      this.item,
      this.bgColor,
      this.onDocumentTapped, this.onDocumentLongPressed);

  @override
  Widget build(BuildContext context) {
    TextStyle? primaryTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    TextStyle? secondaryTextStyle = Theme.of(context).textTheme.bodySmall;
    return Container(
      color: bgColor,
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
                      //borderRadius: BorderRadius.only(
                        //topLeft: Radius.circular(8),
                        //bottomLeft: Radius.circular(8),
                      //),
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
                            style: primaryTextStyle,
                          ),
                          //SizedBox(height: 4),
                          Text(DateFormatFactory.getDateFormat().format(item.date),
                              style: secondaryTextStyle),
                          item.personName != null
                              ? Text(
                            item.personName!,
                              style: secondaryTextStyle
                          )
                              : Container(),
                          item.description.isNotEmpty
                              ? Text(item.description,
                              style: secondaryTextStyle)
                              : Container()
                        ],
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Utils.getQuantityText(item.quantity), style:primaryTextStyle ),
                      Text("${AppLocalizations.of(context)!.field_amount}: ${Config.currencyFormat.format(item.amount)}", style: secondaryTextStyle),
                      Text("${AppLocalizations.of(context)!.field_paid}: ${Config.currencyFormat.format(item.paid)}", style: secondaryTextStyle),
                      Text("${AppLocalizations.of(context)!.field_remaining}: ${Config.currencyFormat.format(item.amount - item.paid)}", style: secondaryTextStyle),
                    ],
                  )
                ],),))
              ],
            ),
          )),
    );
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
