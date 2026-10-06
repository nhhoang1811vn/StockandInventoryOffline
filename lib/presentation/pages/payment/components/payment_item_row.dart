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
  final bool showDate;

  PaymentItemRow(
    this.item,
    this.bgColor,
    this.onPressed,
    this.onLongPressed, {
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    var personName = "";
    if (item.customer != null) {
      personName = item.customer!.name;
    } else if (item.supplier != null) {
      personName = item.supplier!.name;
    }

    final isInbound = item.type == PaymentType.inbound;
    final color = isInbound ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(item),
          onLongPress: () => onLongPressed(item),
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      item.category?.icon ?? "💰",
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category != null
                            ? item.category!.name
                            : context.tr("no_category"),
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (item.wallet != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: WalletShortFormWidget(item.wallet!),
                        ),
                      if (item.document != null || personName.isNotEmpty)
                        Row(
                          children: [
                            if (personName.isNotEmpty) ...[
                              CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Text(
                                  personName[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                item.document != null
                                    ? "${item.document!.name}${personName.isNotEmpty ? " ($personName)" : ""}"
                                    : personName,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (showDate) ...[
                        const SizedBox(height: 4),
                        Text(
                          DateFormatFactory.getDateFormat().format(item.date),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.2),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (item.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${isInbound ? "+" : "-"}${CurrencyFormatter.format(context, item.amount ?? 0)}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
