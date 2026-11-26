import 'package:flutter/material.dart';

import '../../../../domain/entity/entity.dart';
import '../../../widget/sort_by_name_filter.dart';

class FilterSupplierWidget extends StatelessWidget {
  final Function() onResetAllPressed;
  final Function(SuppliersSetting) onApplyPressed;
  final SuppliersSetting setting;

  const FilterSupplierWidget({
    super.key,
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  Widget build(BuildContext context) {
    return SortByNameFilterSheet(
      initial: setting.sortByName,
      onReset: onResetAllPressed,
      onApply: (sort) => onApplyPressed(setting.copyWith(sortByName: sort)),
    );
  }
}
