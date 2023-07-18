import 'package:flutter/material.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/store.dart';

class StoreItemRow extends StatelessWidget{
  final Store item;
  final void Function(Store item) onPressed;
  final void Function(Store item) onLongPressed;
  StoreItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(UIConstants.storeIconPath, width: 32),
      title: Text(item.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.description.isNotEmpty
              ? Text(item.description)
              : Container(),
        ],
      ),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
}