import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment.dart';

import '../../../constants.dart';

class PaymentItemRow extends StatelessWidget {
  final Payment item;
  final void Function(Payment item) onPressed;
  final void Function(Payment item) onLongPressed;

  PaymentItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        child: ListTile(
          title: Text(item.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Config.dateFormat.format(item.date)),
              if (item.description.isNotEmpty)
                Text(
                  item.description,
                  style:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                )
            ],
          ),
          trailing: Text(Config.currencyFormat.format(item.amount ?? 0),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ),
      ),
    );
  }
}
