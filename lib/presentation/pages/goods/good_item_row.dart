import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final double quantity;
  final bool showBarcode;
  final bool showDescription;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;
  final bool isSelection;

  GoodItemRow({
      required this.item,
      required this.quantity,
      required this.showBarcode,
      required this.showDescription,
      required this.onGoodTapped,
      required this.onGoodLongPressed,
      required this.isSelection
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onGoodTapped(item),
        onLongPress: () => onGoodLongPressed(item),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildLeadingWidget(),
              SizedBox(
                width: 16,
              ),
              Expanded(child: _buildWidget(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingWidget() {
    return item.files.isNotEmpty ? getAvatarWidget(item.files.first) : _buildEmptyAvatarWidget();
  }

  Widget _buildWidget(BuildContext context) {
    return Column(
      children: [_buildTop(context), _buildBottom(context)],
    );
  }

  Widget _buildTop(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name,
                style:
                    Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
            SizedBox(height: 4),
            if (showBarcode && item.barCode != null)
              Row(children: [
                Icon(UIConstants.barcodeIconData, size: 24, color: UIConstants.primaryColor),
                SizedBox(
                  width: 8,
                ),
                Text(item.barCode!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onSurface)),
              ]),
            if (showDescription && item.description.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Text(item.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).colorScheme.onSurface)),
                ],
              )
          ]),
        ),
        Text(Utils.getQuantityText(item.quantity),
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(Config.currencyFormat.format(item.purchasePrice ?? 0),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red.shade700)),
        Text("/"),
        Text(Config.currencyFormat.format(item.salePrice ?? 0),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green.shade700)),
      ],
    );
  }

  Widget getAvatarWidget(Uint8List bytes) {
    return SizedBox(width: 32, height: 32, child: Image.memory(bytes));
  }

  Widget _buildEmptyAvatarWidget() {
    return Image(image: AssetImage('assets/images/box.png'), width: 32);
  }
}
