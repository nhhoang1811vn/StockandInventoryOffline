import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/widgets/wallet_short_form_widget.dart';

import '../../../constants.dart';

class PaymentItemRow extends StatelessWidget {
  final Payment item;
  final Color bgColor;
  final void Function(Payment item) onPressed;
  final void Function(Payment item) onLongPressed;

  PaymentItemRow(
      this.item,
      this.bgColor,
      this.onPressed, this.onLongPressed);

  Widget _buildLeadingIcon(Payment item) {
    return item.category != null
        ? Padding(
      padding: EdgeInsets.only(right: 8),
          child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
              child: Center(
                  child: Text(
                item.category!.icon,
                style: TextStyle(fontSize: 24),
              )),
            ),
        )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? primaryTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    TextStyle? subTextStyle = Theme.of(context).textTheme.bodySmall;
    return Container(
      color: bgColor,
      child: InkWell(
          onTap: () => onPressed(item),
          onLongPress: () => onLongPressed(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                _buildLeadingIcon(item),
                //SizedBox(width: 16),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.category != null ? item.category!.name : AppLocalizations.of(context)!.no_category,
                        style: primaryTextStyle),
                    if (item.wallet != null)
                      WalletShortFormWidget(item.wallet!),
                    Text(DateFormatFactory.getDateFormat().format(item.date), style: subTextStyle),
                    if (item.description.isNotEmpty)
                      Text(
                        item.description,
                        style: subTextStyle,
                      ),
                    if (item.document?.name != null && item.document!.name.isNotEmpty)
                      Text(
                        item.document!.name,
                        style: subTextStyle
                      ),
                    if (item.customer != null)
                      Text(item.customer!.name, style: subTextStyle),
                    if (item.supplier != null)
                      Text(item.supplier!.name, style: subTextStyle)
                  ],
                )),
                Text("${item.type == PaymentType.inbound? "+" : "-"}${Config.currencyFormat.format(item.amount ?? 0)}",
                  style: primaryTextStyle
                )
              ],
            ),
          )),
    );
  }
}
