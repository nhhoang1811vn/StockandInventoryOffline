import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/data/app_settings.dart';

import '../../../../domain/entity/entity.dart';
import '../../../../util/currency_formatter.dart';
import '../../../../util/util.dart';

class ItemHistoryRow extends StatelessWidget {
  final GoodHistory item;
  final Color bgColor;
  final Color? incomingColor;
  final Color? outgoingColor;
  final Function(Document document) onDocumentTapped;

  ItemHistoryRow(
    this.item,
    this.bgColor,
    this.incomingColor,
    this.outgoingColor,
    this.onDocumentTapped,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final document = item.document!;
    final isIncoming = document.type == DocumentType.incoming;
    final color = isIncoming
        ? (incomingColor ?? Colors.green)
        : (outgoingColor ?? Colors.red);
    final leadingIcon =
        isIncoming ? Icons.file_download_outlined : Icons.file_upload_outlined;
    final quantityText = isIncoming
        ? "+" + StringUtils.getQuantityText(item.quantity)
        : "-" + StringUtils.getQuantityText(item.quantity);

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
          onTap: () => onDocumentTapped(document),
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: Dimens.tileSize,
                  height: Dimens.tileSize,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimens.tileRadius),
                  ),
                  child: Icon(
                    leadingIcon,
                    color: color,
                    size: Dimens.tileIconSize,
                  ),
                ),
                const SizedBox(width: Dimens.tileGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppSettings.getDocumentPropertiesSettings()
                            .displayName(document, context.tr),
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (document.personName != null &&
                          document.personName!.isNotEmpty)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              child: Text(
                                document.personName![0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                document.personName!,
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
                      const SizedBox(height: 4),
                      Text(
                        DateFormat("hh:mm a").format(document.date),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.2),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      quantityText,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: color),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormatter.format(context, item.amount),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
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
