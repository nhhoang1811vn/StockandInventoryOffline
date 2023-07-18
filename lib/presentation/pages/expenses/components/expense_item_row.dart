import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/expense.dart';

import '../../../../app/utils/constants.dart';


class ExpenseItemRow extends StatelessWidget{
  final Expense item;
  final void Function(Expense item) onPressed;
  final void Function(Expense item) onLongPressed;

  ExpenseItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(Config.dateFormat.format(item.date)),
      trailing: item.amount > 0 ? getPositiveAmount(item.amount) : getNegativeAmount(item.amount),
      onTap:() => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
  Widget getPositiveAmount(amount) {
    return Text(
      "+ $amount",
      style: TextStyle(color: Colors.green),
    );
  }

  Widget getNegativeAmount(amount) {
    return Text(
      amount.toString(),
      style: TextStyle(color: Colors.red),
    );
  }

}