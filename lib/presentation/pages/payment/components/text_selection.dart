import 'package:flutter/material.dart';

import '../../../widget/filter_sheet.dart';

/// Kept for existing call sites; renders the shared filter chip.
class AppTextSelection extends StatelessWidget {
  final Widget? icon;
  final String item;
  final bool isSelected;
  final Function() onPressed;

  const AppTextSelection({
    super.key,
    this.icon,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChoiceChip(
      label: item,
      selected: isSelected,
      onTap: onPressed,
      icon: icon,
    );
  }
}
