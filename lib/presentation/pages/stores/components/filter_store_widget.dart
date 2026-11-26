import 'package:flutter/material.dart';

import '../../../../domain/entity/entity.dart';
import '../../../widget/sort_by_name_filter.dart';

class FilterStoreWidget extends StatelessWidget {
  final Function() onReset;
  final Function(StoresSetting) onApply;
  final StoresSetting settings;

  const FilterStoreWidget({
    super.key,
    required this.onReset,
    required this.onApply,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return SortByNameFilterSheet(
      initial: settings.sortByName,
      onReset: onReset,
      onApply: (sort) => onApply(settings.copyWith(sortByName: sort)),
    );
  }
}
