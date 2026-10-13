import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/currency_formatter.dart';
import '../../../util/util.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final double quantity;
  final bool showBarcode;
  final bool showDescription;
  final bool showPurchasePrice;
  final PriceDisplayMode purchaseDisplayMode;
  final bool showSalePrice;
  final PriceDisplayMode saleDisplayMode;
  final bool showMinQuantity;
  final Color minQuantityColor;
  final Function(Good good) onGoodTapped;
  final Function(Good good) onGoodLongPressed;
  final bool isSelection;
  final bool isGridTile;
  final bool isCompact;

  GoodItemRow({
    required this.item,
    required this.quantity,
    required this.showBarcode,
    required this.showDescription,
    this.showPurchasePrice = true,
    this.purchaseDisplayMode = PriceDisplayMode.price,
    this.showSalePrice = true,
    this.saleDisplayMode = PriceDisplayMode.price,
    required this.showMinQuantity,
    required this.minQuantityColor,
    required this.onGoodTapped,
    required this.onGoodLongPressed,
    required this.isSelection,
    this.isGridTile = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridTile) {
      return _buildGridTile(context);
    }
    return _buildListTile(context);
  }

  Widget _buildListTile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isLowStock =
        item.minQuantity != null && item.quantity < item.minQuantity!;
    final bool isOutOfStock = item.quantity <= 0;

    final bool showBarcodeRow = showBarcode && item.barCode != null;
    final bool showDescriptionRow =
        showDescription && item.description.isNotEmpty;
    final priceRowSegments = _buildPriceRowSegments(context, theme);
    final bool showPriceRow = priceRowSegments.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
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
          onTap: () => onGoodTapped(item),
          onLongPress: () => onGoodLongPressed(item),
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: item.files.isNotEmpty
                        ? Image.memory(item.files.first, fit: BoxFit.cover)
                        : Icon(UIConstants.goodIconData,
                            color: theme.colorScheme.primary, size: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (showBarcodeRow) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.qr_code,
                                size: 14,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.barCode!,
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
                      ],
                      if (showDescriptionRow) ...[
                        SizedBox(height: showBarcodeRow ? 4 : 6),
                        Text(
                          item.description,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (showPriceRow) ...[
                        SizedBox(
                            height:
                                (showBarcodeRow || showDescriptionRow) ? 4 : 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: priceRowSegments,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringUtils.getQuantityText(item.quantity),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isOutOfStock
                                ? Colors.red
                                : (isLowStock
                                    ? Colors.orange
                                    : theme.colorScheme.onSurface),
                          ),
                    ),
                    if (isLowStock || isOutOfStock) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isOutOfStock
                              ? context.tr("out_of_stock")
                              : context.tr("low_stock"),
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isLowStock =
        item.minQuantity != null && item.quantity < item.minQuantity!;
    final bool isOutOfStock = item.quantity <= 0;
    final priceRowSegments = _buildPriceRowSegments(
      context,
      theme,
      compact: isCompact,
    );
    final imageSize = isCompact ? 40.0 : 54.0;
    final iconSize = isCompact ? 20.0 : 24.0;
    final nameSize = isCompact ? 12.0 : 13.0;
    final padding = isCompact ? 8.0 : 12.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
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
            onTap: () => onGoodTapped(item),
            onLongPress: () => onGoodLongPressed(item),
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: item.files.isNotEmpty
                          ? Image.memory(item.files.first, fit: BoxFit.cover)
                          : Icon(
                              UIConstants.goodIconData,
                              color: theme.colorScheme.primary,
                              size: iconSize,
                            ),
                    ),
                  ),
                  SizedBox(height: isCompact ? 6 : 8),
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: nameSize,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: isCompact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    StringUtils.getQuantityText(item.quantity),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: isCompact ? 12 : null,
                      color: isOutOfStock
                          ? Colors.red
                          : (isLowStock
                              ? Colors.orange
                              : theme.colorScheme.onSurface),
                    ),
                  ),
                  if (priceRowSegments.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Flexible(
                      child: ClipRect(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4,
                          runSpacing: 2,
                          children: priceRowSegments,
                        ),
                      ),
                    ),
                  ],
                  if (isLowStock || isOutOfStock) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isOutOfStock
                            ? context.tr("out_of_stock")
                            : context.tr("low_stock"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: isCompact ? 8 : 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPriceRowSegments(
    BuildContext context,
    ThemeData theme, {
    bool compact = false,
  }) {
    final segments = <Widget>[];
    final dividerColor = theme.colorScheme.onSurface.withValues(alpha: 0.3);
    final fontSize = compact ? 11.0 : 13.0;
    final saleFontSize = compact ? 11.0 : 14.0;

    void addDivider() {
      if (segments.isNotEmpty) {
        segments.add(Text('·',
            style: TextStyle(
                color: dividerColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600)));
      }
    }

    if (showPurchasePrice) {
      addDivider();
      segments.add(
        Text(
          CurrencyFormatter.format(
              context, _displayValue(item.purchasePrice, purchaseDisplayMode)),
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (showSalePrice) {
      addDivider();
      segments.add(
        Text(
          CurrencyFormatter.format(
              context, _displayValue(item.salePrice, saleDisplayMode)),
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: saleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (showMinQuantity && item.minQuantity != null) {
      addDivider();
      segments.add(
        Text(
          '${context.tr("min_quantity_short_form")} ${StringUtils.getQuantityText(item.minQuantity!)}',
          style: TextStyle(
            color: minQuantityColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return segments;
  }

  double _displayValue(double? price, PriceDisplayMode mode) {
    final unit = price ?? 0;
    if (mode == PriceDisplayMode.amount) {
      return unit * quantity;
    }
    return unit;
  }
}
