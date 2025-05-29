
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
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
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
                            item.document?.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          //SizedBox(height: 4),
                          Text(DateFormatFactory.getDateFormat().format(item.document!.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
                          //SizedBox(height: 4),
                          item.document!.personName != null
                              ? Text(
                            item.document!.personName!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onSurface),
                          )
                              : Container(),
                          item.document!.description.isNotEmpty
                              ? Text(item.document!.description,
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
                      Text(quantityText, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                      //Text("Paid/Amount"),
                      Text(item.amount.toString())
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
      case DocumentType.outgoing:
        return Colors.green;
      }
  }
}