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
  final DocumentType _documentType;

  GoodItemRow(
      this.item, this.quantity, this.onGoodTapped, this.onGoodLongPressed,
      [this.isSelection = false, this._documentType]);

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
              ? getPendingView()
              : Container()
        ]),
        leading: Icon(Icons.image, size: 36, color: Colors.blue),
        onTap: () => onGoodTapped(item),
        onLongPress: () => onGoodLongPressed(item));
  }

  Widget getPendingView() {
    if (_documentType == DocumentType.incoming) {
      if (item.pendingQuantity > 0) {
        return getGreenTextView(item.pendingQuantity);
      } else {
        return getRedTextView(-item.pendingQuantity);
      }
    } else {
      if (item.pendingQuantity > 0) {
        return getRedTextView(item.pendingQuantity);
      } else {
        return getGreenTextView(-item.pendingQuantity);
      }
    }
  }

  Widget getGreenTextView(int quantity) {
    return Text(" + " + quantity.toString(),
        style: TextStyle(fontSize: 16, color: Colors.green));
  }

  Widget getRedTextView(int quantity) {
    return Text(" - " + quantity.toString(),
        style: TextStyle(fontSize: 16, color: Colors.red));
  }
}
