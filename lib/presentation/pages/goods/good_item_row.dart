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
    return InkWell(
      //borderRadius: BorderRadius.circular(8),
      onTap: () => onGoodTapped(item),
      onLongPress: () => onGoodLongPressed(item),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildLeadingWidget(context),
            SizedBox(
              width: 16,
            ),
            Expanded(child: _buildTop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingWidget(BuildContext context) {
    return item.files.isNotEmpty
        ? getAvatarWidget(item.files.first)
        : _buildEmptyAvatarWidget(context);
  }

  Widget _buildTop(BuildContext context) {
    TextStyle? primaryTextStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w700);
    TextStyle? secondaryTextStyle = Theme.of(context).textTheme.bodySmall;
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
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: primaryTextStyle),
              SizedBox(height: 4),
              if (showBarcode && item.barCode != null)
                Row(
                  children: [
                    Icon(
                      UIConstants.barcodeIconData,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(item.barCode!, style: secondaryTextStyle),
                  ],
                ),
              if (showDescription && item.description.isNotEmpty)
                Column(
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(item.description, style: secondaryTextStyle),
                  ],
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              StringUtils.getQuantityText(item.quantity),
              style: primaryTextStyle?.copyWith(color: quantityColor),
            ),
            if (showMinQuantity)
              Row(
                children: [
                  Text(
                    context.tr("min_quantity_short_form"),
                    style: secondaryTextStyle,
                  ),
                  Text(
                    StringUtils.getQuantityText(item.minQuantity ?? 0),
                    style: secondaryTextStyle,
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(context,item.purchasePrice ?? 0),
                  style: secondaryTextStyle?.copyWith(
                    color: Colors.red.shade700,
                  ),
                ),
                Text("/"),
                Text(
                CurrencyFormatter.format(context,item.salePrice ?? 0),
                  style: secondaryTextStyle?.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getAvatarWidget(Uint8List bytes) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipOval(
        child: Image.memory(
          bytes,
          fit:
              BoxFit.cover, // Ensures the image covers the entire circular area
        ),
      ),
    );
  }

  Widget _buildEmptyAvatarWidget(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Icon(
          UIConstants.goodIconData,
          size: 36,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
