import 'package:flutter/material.dart';
import 'package:good_manager/util/currency_formatter.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../util/util.dart';

class DocumentTransactionItemRow extends StatelessWidget {
  final DocumentTransaction item;
  final Color bgColor;
  final Function(DocumentTransaction item) onTransactionPressed;
  final Function(DocumentTransaction item) onTransactionLongPressed;
  final bool isSelection;

  DocumentTransactionItemRow(this.item,
      this.bgColor,
      this.onTransactionPressed,
      this.onTransactionLongPressed, [
        this.isSelection = false,
      ]);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = (item.price ?? 0) * item.quantity;
    final good = item.good;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.screenPadding, vertical: 6),
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
          onTap: () => onTransactionPressed(item),
          onLongPress: () => onTransactionLongPressed(item),
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.cardPadding),
            child: Row(
              children: [
                Container(
                  width: Dimens.tileSize,
                  height: Dimens.tileSize,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimens.tileRadius),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.tileRadius),
                    child: good.files.isNotEmpty
                        ? Image.memory(good.files.first, fit: BoxFit.cover)
                        : Icon(UIConstants.goodIconData,
                            color: theme.colorScheme.primary, size: 28),
                  ),
                ),
                const SizedBox(width: Dimens.tileGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        good.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (good.barCode != null && good.barCode!.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.qr_code,
                                size: 14,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5)),
                            const SizedBox(width: 6),
                            Text(
                              good.barCode!,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            CurrencyFormatter.format(context, item.price ?? 0),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              CurrencyFormatter.format(context, total),
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringUtils.getQuantityText(item.quantity),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
