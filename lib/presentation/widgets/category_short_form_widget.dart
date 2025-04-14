
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment_category.dart';

class CategoryShortFormWidget extends StatelessWidget{
  final PaymentCategory item;
  CategoryShortFormWidget(this.item);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(item.icon, style: TextStyle(fontSize: 20)),
      SizedBox(width: 8),
      Expanded(child: Text(item.name, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis))

    ]);
  }
}
