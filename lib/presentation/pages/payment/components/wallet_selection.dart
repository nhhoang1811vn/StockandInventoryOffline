import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/wallet.dart';

import '../../../constants.dart';

class WalletSelection extends StatelessWidget {
  Wallet item;
  bool isSelected;
  final void Function() onPressed;

  WalletSelection({
    required this.item,
    required this.isSelected,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    final bgColor = isDarkMode
        ? Colors.grey[800] // Darker background for dark mode
        : Colors.grey[300];

    return InkWell(
      onTap: () {
        onPressed();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
          decoration: isSelected
              ? BoxDecoration(
            color: bgColor,
                  border: Border.all(
                    color: Colors.blue.shade700,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                )
              : BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ), // No decoration if not selected

          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(UIConstants.walletIconData, color: Color(item.color), size: 24),
                SizedBox(height: 4),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ])),
    );
  }
}
