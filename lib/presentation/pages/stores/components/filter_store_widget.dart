import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/goods/component/goods_sheet_common.dart';

import '../../../../domain/entity/entity.dart';

class FilterStoreWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(StoresSetting) onApplyPressed;
  final StoresSetting setting;

  FilterStoreWidget({
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterStoreWidgetState();
  }
}

class FilterStoreWidgetState extends State<FilterStoreWidget> {
  SortByText _sortByName = SortByText.no_sort;

  @override
  void initState() {
    super.initState();
    _sortByName = widget.setting.sortByName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GoodsSheetHeader(title: context.tr("title_filter")),
          const SizedBox(height: 16),
          GoodsSheetSectionHeader(context.tr("sort_by_name")),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: SortByText.values
                .map(
                  (item) => GoodsSheetChip(
                    label: item.getText(context),
                    isSelected: _sortByName == item,
                    onTap: () => setState(() => _sortByName = item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 40),
          GoodsSheetActions(
            onResetAllPressed: widget.onResetAllPressed,
            onApplyPressed: () {
              widget.onApplyPressed(
                widget.setting.copyWith(sortByName: _sortByName),
              );
            },
          ),
        ],
      ),
    );
  }
}
