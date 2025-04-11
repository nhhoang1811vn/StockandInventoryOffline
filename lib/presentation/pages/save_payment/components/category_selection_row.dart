import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment_category.dart';

class CategorySelectionRow extends StatelessWidget {
  final PaymentCategory item;
  final void Function(PaymentCategory item) onPressed;
  final void Function(PaymentCategory item) onLongPressed;
  final bool isSelected;

  CategorySelectionRow(this.item, this.onPressed, this.onLongPressed, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        child: ListTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(item.color),
              shape: BoxShape.circle
            ),
          ),

          trailing: isSelected ? Icon(Icons.radio_button_checked, color: Colors.blue,) : Icon(Icons.radio_button_off, color: Colors.blue,),
          title: Text(item.name,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ),
    );
  }
}
