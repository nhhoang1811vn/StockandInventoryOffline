import 'dart:typed_data';

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
  final bool showMinQuantity;
  final Color minQuantityColor;
  final Function(Good good) onGoodTapped;
  final Function(Good good) onGoodLongPressed;
  final bool isSelection;

  GoodItemRow({
    required this.item,
    required this.quantity,
    required this.showBarcode,
    required this.showDescription,
    required this.showMinQuantity,
    required this.minQuantityColor,
    required this.onGoodTapped,
    required this.onGoodLongPressed,
    required this.isSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onGoodTapped(item),
        onLongPress: () => onGoodLongPressed(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeadingWidget(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleRow(context),
                    const SizedBox(height: 4),
                    _buildSubtitleColumn(context),
                    const SizedBox(height: 8),
                    _buildPriceRow(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingWidget(BuildContext context) {
    return SizedBox(
        width: 48,
        height: 48, child:
    item.files.isNotEmpty
        ?_getAvatarWidget(item.files.first)
        :_buildEmptyAvatarWidget(context)
    );
  }

  Widget _getAvatarWidget(Uint8List bytes) {
    return ClipOval(
      child: Image.memory(
        bytes,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    var quantityColor = Theme.of(context).colorScheme.onSurface;
    if (item.minQuantity == null) {
      if (item.quantity < 0) {
        quantityColor = minQuantityColor;
      }
    } else {
      if (item.quantity < item.minQuantity!) {
        quantityColor = minQuantityColor;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          StringUtils.getQuantityText(item.quantity),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: quantityColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitleColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBarcode && item.barCode != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Row(
              children: [
                Icon(
                  UIConstants.barcodeIconData,
                  size: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  item.barCode!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        if (showDescription && item.description.isNotEmpty)
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showMinQuantity)
          Row(
            children: [
              Text(
                "${context.tr("min_quantity_short_form")}: ",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                StringUtils.getQuantityText(item.minQuantity ?? 0),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        else
          const Spacer(),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                CurrencyFormatter.format(context, item.purchasePrice ?? 0),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text("/", style: TextStyle(color: Colors.grey)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                CurrencyFormatter.format(context, item.salePrice ?? 0),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyAvatarWidget(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(
        UIConstants.goodIconData,
        size: 24,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
