import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment_category.dart';

class CategorySelection extends StatelessWidget {
  final PaymentCategory item;
  final bool isSelected;
  final void Function() onPressed;
  final void Function()? onLongPressed;

  CategorySelection({
    required this.item,
    required this.isSelected,
    required this.onPressed,
    this.onLongPressed
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    final bgColor = isDarkMode
        ? Colors.grey[800] // Darker background for dark mode
        : Colors.grey[300];

    return InkWell(
      onLongPress: onLongPressed,
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
                Text(item.icon, style: TextStyle(fontSize: 28)),
                SizedBox(height: 4),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ])),
    );
  }
}
