import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';

class WalletSelection extends StatelessWidget {
  final Wallet item;
  final bool isSelected;
  final Function() onPressed;
  final bool showBalance;

  WalletSelection({
    required this.item,
    required this.isSelected,
    required this.showBalance,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            Icon(
              UIConstants.walletIconData,
              color: Color(item.color),
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              item.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (showBalance)
              Text(
                Config.currencyFormat.format(item.balance),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
