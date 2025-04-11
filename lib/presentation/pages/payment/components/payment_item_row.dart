import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/widgets/category_short_form_widget.dart';
import 'package:good_manager/presentation/widgets/wallet_short_form_widget.dart';

import '../../../constants.dart';
class PaymentItemRow extends StatelessWidget {
  final Payment item;
  final void Function(Payment item) onPressed;
  final void Function(Payment item) onLongPressed;

  PaymentItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        child: ListTile(
          title: item.category != null ? CategoryShortFormWidget(item.category!) : Text(AppLocalizations.of(context)!.no_category),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.wallet != null ? WalletShortFormWidget(item.wallet!) : Text("No wallet"),
              Text(DateFormatFactory.getDateFormat().format(item.date)),
              if (item.description.isNotEmpty)
                Text(
                  item.description,
                  style:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              if (item.document?.name != null && item.document!.name.isNotEmpty)
                Text(
                  item.document!.name,
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
