import 'package:flutter/material.dart';

import '../../constant/constant.dart';
import '../../domain/entity/entity.dart';

class WalletShortFormWidget extends StatelessWidget {
  final Wallet item;

  WalletShortFormWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(UIConstants.walletIconData, size: 18, color: Color(item.color)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            item.name,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
