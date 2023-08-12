import 'dart:io';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final int quantity;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;
  final bool isSelection;

  GoodItemRow(
      this.item, this.quantity, this.onGoodTapped, this.onGoodLongPressed,
      [this.isSelection = false]);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          item.name,
          style: AppStyle.getTitleListTitleStyle(),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: item.description.isNotEmpty,
              child: Text(
                item.description,
                style: AppStyle.getSubTitleListTitleStyle(),
              ),
            ),
            if (item.barCode != null)
              Row(children: [
                Icon(UIConstants.barcodeIconData, size: 24,color: UIConstants.primaryColor),
                SizedBox(
                  width: 8,
                ),
                Text(item.barCode!, style: AppStyle.getSubTitleListTitleStyle())
              ])
          ],
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(quantity.toString(), style: AppStyle.getTrailingListTitleStyle()),
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

  Widget get emptyAvatarWidget => Icon(UIConstants.goodIconData, size: 32,color: UIConstants.primaryColor);
}
