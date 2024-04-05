import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/constants.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final double quantity;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;
  final bool isSelection;

  GoodItemRow(this.item, this.quantity, this.onGoodTapped, this.onGoodLongPressed, [this.isSelection = false]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onGoodTapped(item),
      onLongPress: () => onGoodLongPressed(item),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          children: [
            _buildLeadingWidget(),
            SizedBox(
              width: 8,
            ),
            Expanded(child: _buildWidget(context))
          ],
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
            if (item.barCode != null)
              Row(children: [
                Icon(UIConstants.barcodeIconData, size: 24, color: UIConstants.primaryColor),
                SizedBox(
                  width: 8,
                ),
                Text(item.barCode!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground)),
              ]),
            if (item.description.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Text(item.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).colorScheme.onBackground)),
                ],
              )
          ]),
        ),
        Text(item.quantity.toString(),
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground)),
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(Config.currencyFormat.format(item.purchasePrice ?? 0),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.red.shade700)),
        Text("/"),
        Text(Config.currencyFormat.format(item.salePrice ?? 0),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.green.shade700)),
      ],
    );
  }

  Widget getAvatarWidget(Uint8List bytes) {
    return SizedBox(width: 48, height: 48, child: Image.memory(bytes));
  }

  Widget _buildEmptyAvatarWidget() {
    return SizedBox(
        width: 48, height: 48, child: Icon(UIConstants.goodIconData, size: 32, color: UIConstants.primaryColor));
  }
}
