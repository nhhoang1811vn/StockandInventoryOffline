
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good_history.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';

class ItemHistoryRow extends StatelessWidget{
  final GoodHistory item;
  final void Function(Document document) onDocumentTapped;
  ItemHistoryRow(this.item, this.onDocumentTapped);

  @override
  Widget build(BuildContext context) {
    String quantityText;
    if (item.document!.type == DocumentType.incoming){
      quantityText = "+ " + Utils.getQuantityText(item.quantity);
    }else{
      quantityText = "- " + Utils.getQuantityText(item.quantity);
    }
    return InkWell(
          onTap: () => onDocumentTapped(item.document!),
          //onLongPress: () => onDocumentLongPressed(item),
    child:  Container(
        padding: EdgeInsets.fromLTRB(16, 8 , 16 , 8),
        child: Column(
          children: [
            //Align(alignment: Alignment.centerRight, child: _buildPaymentStatusWidget()),
            IntrinsicHeight(
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 10,
                      color: getIndicatorColor(item.document!.type),
                      //child: Column(),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.document?.name ?? "",
                              style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                            ),
                            //SizedBox(height: 4),
                            Text(DateFormatFactory.getDateFormat().format(item.document!.date), style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onSurface)),
                            //SizedBox(height: 4),
                            item.document!.personName != null ? Text(item.document!.personName!, style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onSurface),) : Container(),
                            item.document!.description.isNotEmpty ? Text(item.document!.description, style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onSurface)) : Container()
                          ],
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(quantityText, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                        Text(Config.currencyFormat.format(item.amount))
                      ],
                    )

                  ],
                ))
          ],
        ),
      ));
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