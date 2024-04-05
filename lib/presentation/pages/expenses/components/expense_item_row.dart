import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/expense.dart';

import '../../../constants.dart';

class ExpenseItemRow extends StatelessWidget {
  final Expense item;
  final void Function(Expense item) onPressed;
  final void Function(Expense item) onLongPressed;

  ExpenseItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name, style:
      Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
      subtitle: Text(
        Config.dateFormat.format(item.date),
        style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      trailing: Text(Config.currencyFormat.format(item.amount??0),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground)),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
}
