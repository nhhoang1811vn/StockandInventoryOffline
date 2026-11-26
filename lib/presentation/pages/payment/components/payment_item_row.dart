import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:good_manager/util/dimen.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';

class PaymentItemRow extends StatelessWidget {
  final Payment item;
  final Color bgColor;
  final Function(Payment item) onPressed;
  final Function(Payment item) onLongPressed;
  final bool showDate;
  final EdgeInsets margin;

  PaymentItemRow(
    this.item,
    this.bgColor,
    this.onPressed,
    this.onLongPressed, {
    this.showDate = true,
    this.margin = const EdgeInsets.symmetric(vertical: 6),
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
      margin: margin,
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.015),
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
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.cardPadding),
            child: Row(
              children: [
                Container(
                  width: Dimens.tileSize,
                  height: Dimens.tileSize,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimens.tileRadius),
                  ),
                  child: Center(
                    child: Text(
                      item.category?.icon ?? "💰",
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: Dimens.tileGap),
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
                                    fontSize: 12,
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
                                    ? "${AppSettings.getDocumentPropertiesSettings().displayName(item.document!, context.tr)}${personName.isNotEmpty ? " ($personName)" : ""}"
                                    : personName,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
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
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.2),
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
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
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
