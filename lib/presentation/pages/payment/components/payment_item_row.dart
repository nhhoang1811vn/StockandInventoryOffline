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
    return ListTile(
      title: Text(Config.dateFormat.format(item.date), style:
      Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
      subtitle: Text(item.description, style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onSurface),),
      trailing: Text(Config.currencyFormat.format(item.amount??0),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
}
