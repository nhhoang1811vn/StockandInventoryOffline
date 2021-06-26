import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final int quantity;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;
  final bool isSelection;
  final DocumentType documentType;

  GoodItemRow(
      this.item, this.quantity, this.onGoodTapped, this.onGoodLongPressed,
      [this.isSelection = false, this.documentType = DocumentType.incoming]);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          item.name,
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: item.description.isNotEmpty,
              child: Text(
                item.description,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Visibility(
                visible: item.barCode.isNotEmpty,
                child: Row(children: [
                  Icon(FontAwesomeIcons.barcode),
                  SizedBox(
                    width: 8,
                  ),
                  Text(item.barCode, style: TextStyle(fontSize: 14))
                ]))
          ],
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(quantity.toString(), style: TextStyle(fontSize: 16)),
          (isSelection && item.pendingQuantity != 0)
              ? pendingQuantity
              : Container()
        ]),
        leading: Icon(Icons.image, size: 36, color: Colors.blue),
        onTap: () => onGoodTapped(item),
        onLongPress: () => onGoodLongPressed(item));
  }

  Widget get pendingQuantity => (documentType == DocumentType.incoming
      ? incomingQuantity
      : outgoingQuantity);

  Widget get incomingQuantity => Text(" + " + item.pendingQuantity.toString(),
      style: TextStyle(fontSize: 16, color: Colors.green));

  Widget get outgoingQuantity => Text(" - " + item.pendingQuantity.toString(),
      style: TextStyle(fontSize: 16, color: Colors.red));
}
