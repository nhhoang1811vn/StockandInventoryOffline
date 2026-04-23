import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
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

  DocumentTransactionItemRow(
      this.item,
      this.bgColor,
      this.onTransactionPressed,
      this.onTransactionLongPressed, [
        this.isSelection = false,
      ]);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onTransactionPressed(item),
        onLongPress: () => onTransactionLongPressed(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
    if (item.good?.files.isNotEmpty ?? false) {
      return SizedBox(
        width: 48,
        height: 48,
        child: ClipOval(
          child: Image.memory(
            item.good!.files.first,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        UIConstants.goodIconData,
        size: 28,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item.good?.name ?? "",
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
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitleColumn(BuildContext context) {
    var description = item.good?.description ?? "";
    var barcode = item.good?.barCode ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (barcode.isNotEmpty)
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
                  barcode,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        if (description.isNotEmpty)
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    final price = item.price ?? 0;
    final total = price * item.quantity;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${context.tr("price")}: ${CurrencyFormatter.format(context, price)}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "${context.tr("total")}: ${CurrencyFormatter.format(context, total)}",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
