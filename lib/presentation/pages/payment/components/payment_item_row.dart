import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:good_manager/util/currency_formatter.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';

class PaymentItemRow extends StatelessWidget {
  final Payment item;
  final Color bgColor;
  final Function(Payment item) onPressed;
  final Function(Payment item) onLongPressed;

  PaymentItemRow(this.item, this.bgColor, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    var personName = "";
    if (item.customer != null) {
      personName = item.customer!.name;
    } else if (item.supplier != null) {
      personName = item.supplier!.name;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildLeadingIcon(item),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category != null
                          ? item.category!.name
                          : context.tr("no_category"),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (item.wallet != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: WalletShortFormWidget(item.wallet!),
                      ),
                    Text(
                      DateFormatFactory.getDateFormat().format(item.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (item.description.isNotEmpty)
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (item.document != null || personName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          item.document != null
                              ? "${item.document!.name}${personName.isNotEmpty ? " ($personName)" : ""}"
                              : personName,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${item.type == PaymentType.inbound ? "+" : "-"}${CurrencyFormatter.format(context, item.amount ?? 0)}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: item.type == PaymentType.inbound
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(Payment item) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          item.category?.icon ?? "💰",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
