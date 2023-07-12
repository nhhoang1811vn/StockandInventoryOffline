import 'dart:io';

import 'package:flutter/material.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final int quantity;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;
  final bool isSelection;
  final DocumentType? _documentType;

  GoodItemRow(
      this.item, this.quantity, this.onGoodTapped, this.onGoodLongPressed,
      [this.isSelection = false, this._documentType]);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
        color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16);
    const bodyStyle = TextStyle(fontSize: 14);
    return ListTile(
        title: Text(
          item.name,
          style: titleStyle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: item.description.isNotEmpty,
              child: Text(
                item.description,
                style: bodyStyle,
              ),
            ),
            if (item.barCode != null)
              Row(children: [
                Image.asset(
                  UIConstants.barcodeIconPath,
                  width: 24,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(item.barCode, style: bodyStyle)
              ])
          ],
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(quantity.toString(), style: TextStyle(fontSize: 16)),
          (isSelection && item.pendingQuantity != 0)
              ? getPendingView()
              : Container()
        ]),
        leading: item.files.isNotEmpty
            ? getAvatarWidget(item.files.first)
            : emptyAvatarWidget,
        onTap: () => onGoodTapped(item),
        onLongPress: () => onGoodLongPressed(item));
  }

  Widget getAvatarWidget(String path) {
    return Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: FileImage(File(path)), fit: BoxFit.fill)));
  }

  Widget get emptyAvatarWidget => Image.asset(
        UIConstants.goodIconPath,
        width: 36,
      );

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
