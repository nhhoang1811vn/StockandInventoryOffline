import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/presentation/app_style.dart';

import '../../../constants.dart';

class ExpenseItemRow extends StatelessWidget {
  final Expense item;
  final void Function(Expense item) onPressed;
  final void Function(Expense item) onLongPressed;

  ExpenseItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name, style: AppStyle.getTitleListTitleStyle()),
      subtitle: Text(
        Config.dateFormat.format(item.date),
        style: AppStyle.getSubTitleListTitleStyle(),
      ),
      trailing: Text(Config.currencyFormat.format(item.amount),
          style: AppStyle.getTrailingListTitleStyle()),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
}
