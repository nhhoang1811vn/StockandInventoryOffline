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
    return Card(
        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                Text(
                  DateFormatFactory.getDateFormat().format(item.date),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            )),
            Text(Config.currencyFormat.format(item.amount ?? 0),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface))
          ],
        ),
      ),
    ));
    /*return ListTile(
      title: Text(item.name, style:
      Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
      subtitle: Text(
        DateFormatFactory.getDateFormat().format(item.date),
        style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
      trailing: Text(Config.currencyFormat.format(item.amount??0),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );*/
  }
}
