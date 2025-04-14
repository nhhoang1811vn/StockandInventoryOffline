import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/presentation/constants.dart';

class WalletShortFormWidget extends StatelessWidget {
  final Wallet item;

  WalletShortFormWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(UIConstants.walletIconData, size: 20, color: Color(item.color)),
      SizedBox(width: 8),
      Expanded(child: Text(item.name, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis,))
    ]);
  }
}
