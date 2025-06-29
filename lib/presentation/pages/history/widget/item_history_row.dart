
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good_history.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';

class ItemHistoryRow extends StatelessWidget{
  final GoodHistory item;
  final Color bgColor;
  final Color? incomingColor;
  final Color? outgoingColor;
  final void Function(Document document) onDocumentTapped;
  ItemHistoryRow(
      this.item,
      this.bgColor,
      this.incomingColor,
      this.outgoingColor,
      this.onDocumentTapped);

  @override
  Widget build(BuildContext context) {

    TextStyle? primaryTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    TextStyle? secondaryTextStyle = Theme.of(context).textTheme.bodySmall;

    String quantityText;
    if (item.document!.type == DocumentType.incoming){
      quantityText = "+" + Utils.getQuantityText(item.quantity);
    }else{
      quantityText = "-" + Utils.getQuantityText(item.quantity);
    }
    return Container(
      color: bgColor,
      padding: EdgeInsets.all(16),
      child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onDocumentTapped(item.document!),
          //onLongPress: () => onDocumentLongPressed(item),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getIndicatorColor(item.document!.type), // Change color as needed
                      borderRadius: BorderRadius.all(Radius.circular(8)
                        //topLeft: Radius.circular(8),
                        //bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(child: Row(children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.document?.name ?? "",
                            style: primaryTextStyle,
                          ),
                          //SizedBox(height: 4),
                          Text(DateFormatFactory.getDateFormat().format(item.document!.date),
                              style: secondaryTextStyle),
                          //SizedBox(height: 4),
                          item.document!.personName != null
                              ? Text(
                            item.document!.personName!,
                            style: secondaryTextStyle,
                          )
                              : Container(),
                          item.document!.description.isNotEmpty
                              ? Text(item.document!.description,
                              style: secondaryTextStyle)
                              : Container()
                        ],
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(quantityText, style: primaryTextStyle),
                      Text("${Config.currencyFormat.format(item.amount)}", style: secondaryTextStyle),
                      //Text(item.amount.toString())
                    ],
                  )
                ],))
              ],
            ),
          )),
    );
  }
  Color? getIndicatorColor(DocumentType type) {
    switch (type) {
      case DocumentType.incoming:
        return incomingColor;
      default:
        return outgoingColor;
    }
  }
}