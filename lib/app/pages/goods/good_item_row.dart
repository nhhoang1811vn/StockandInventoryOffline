import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:good_manager/domain/entities/good.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;

  GoodItemRow(this.item, this.onGoodTapped, this.onGoodLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          item.name,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.description),
        trailing: Text(item.quantity.toString()),
        leading: Icon(Icons.image, size: 36, color: Colors.blue),
        onTap: () => onGoodTapped(item),
        onLongPress: () => onGoodLongPressed(item));
  }
}
