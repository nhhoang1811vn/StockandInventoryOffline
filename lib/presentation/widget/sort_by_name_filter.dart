import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_tokens.dart';
import '../../domain/entity/entity.dart';
import 'filter_sheet.dart';

/// Shared bottom-sheet content for list screens whose only filter is
/// "sort by name" (customers, suppliers, stores).
class SortByNameFilterSheet extends StatefulWidget {
  final SortByText initial;
  final VoidCallback onReset;
  final ValueChanged<SortByText> onApply;

  const SortByNameFilterSheet({
    super.key,
    required this.initial,
    required this.onReset,
    required this.onApply,
  });

  @override
  State<SortByNameFilterSheet> createState() => _SortByNameFilterSheetState();
}

class _SortByNameFilterSheetState extends State<SortByNameFilterSheet> {
  late SortByText _sortByName = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const FilterSheetHeader(),
          FilterSectionTitle(context.tr('sort_by_name')),
          FilterChipWrap(children: [
            for (final item in SortByText.values)
              FilterChoiceChip(
                label: item.getText(context),
                selected: _sortByName == item,
                onTap: () => setState(() => _sortByName = item),
              ),
          ]),
          FilterSheetActions(
            onReset: widget.onReset,
            onApply: () => widget.onApply(_sortByName),
          ),
        ],
      ),
    );
  }
}
