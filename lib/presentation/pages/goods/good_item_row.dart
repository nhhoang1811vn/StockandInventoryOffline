import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final double quantity;
  final bool showBarcode;
  final bool showDescription;
  final bool showMinQuantity;
  final Color minQuantityColor;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;
  final bool isSelection;

  GoodItemRow(
      {required this.item,
      required this.quantity,
      required this.showBarcode,
      required this.showDescription,
      required this.showMinQuantity,
      required this.minQuantityColor,
      required this.onGoodTapped,
      required this.onGoodLongPressed,
      required this.isSelection});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
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
              Expanded(child: _buildTop(context))
            ],
          ),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
            SizedBox(height: 4),
            if (showBarcode && item.barCode != null)
              Row(children: [
                Icon(UIConstants.barcodeIconData,
                    size: 24, color: Theme.of(context).colorScheme.primary),
                SizedBox(
                  width: 8,
                ),
                Text(item.barCode!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ]),
            if (showDescription && item.description.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Text(item.description,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                ],
              )
          ]),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Utils.getQuantityText(item.quantity),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: quantityColor)),
            if (showMinQuantity)
              Row(
                children: [
                  Text(
                      AppLocalizations.of(context)!
                          .field_min_quantity_short_form,
                      style: Theme.of(context).textTheme.bodySmall),
                  Text(Utils.getQuantityText(item.minQuantity ?? 0),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(Config.currencyFormat.format(item.purchasePrice ?? 0),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.red.shade700)),
                Text("/"),
                Text(Config.currencyFormat.format(item.salePrice ?? 0),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.green.shade700)),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget getAvatarWidget(Uint8List bytes) {
    return SizedBox(width: 32, height: 32, child: Image.memory(bytes));
  }

  Widget _buildEmptyAvatarWidget(BuildContext context) {
    return Icon(UIConstants.goodIconData,
        size: 32, color: Theme.of(context).colorScheme.primary);
  }
}
