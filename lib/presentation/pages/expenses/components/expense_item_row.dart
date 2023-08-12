import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/style_size.dart';

import '../../../constants.dart';


class ExpenseItemRow extends StatelessWidget{
  final Expense item;
  final void Function(Expense item) onPressed;
  final void Function(Expense item) onLongPressed;

  ExpenseItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name, style: AppStyle.getTitleListTitleStyle()),
      subtitle: Text(Config.dateFormat.format(item.date), style: AppStyle.getSubTitleListTitleStyle(),),
      trailing: item.amount > 0 ? getPositiveAmount(Config.expenseAmountFormat.format(item.amount)) : getNegativeAmount(Config.expenseAmountFormat.format(item.amount)),
      onTap:() => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
  Widget getPositiveAmount(amount) {
    return Text(
      "+ $amount",
      style: TextStyle(color: Colors.green, fontSize: TextSize.large),
    );
  }

  Widget getNegativeAmount(amount) {
    return Text(
      amount.toString(),
      style: TextStyle(color: Colors.red,fontSize: TextSize.large),
    );
  }

}