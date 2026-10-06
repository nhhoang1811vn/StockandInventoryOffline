import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/goods/component/goods_sheet_common.dart';

import '../../../../domain/entity/entity.dart';

class FilterTransactionWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(SaveDocumentSetting setting) onApplyPressed;
  final SaveDocumentSetting setting;

  FilterTransactionWidget({
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterTransactionWidgetState();
  }
}

class FilterTransactionWidgetState extends State<FilterTransactionWidget> {
  SortByText _sortByName = SortByText.no_sort;
  SortByNumber _sortByBarCode = SortByNumber.no_sort;
  SortByNumber _sortByQuantity = SortByNumber.no_sort;

  @override
  void initState() {
    super.initState();
    _sortByName = widget.setting.sortByName;
    _sortByBarCode = widget.setting.sortByBarcode;
    _sortByQuantity = widget.setting.sortByQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GoodsSheetHeader(title: context.tr("action_sort_by")),
          const SizedBox(height: 16),
          GoodsSheetSectionHeader(context.tr("sort_by_name")),
          _buildOptions(
            SortByText.values.map(
              (item) => GoodsSheetChip(
                label: item.getText(context),
                isSelected: _sortByName == item,
                onTap: () => setState(() => _sortByName = item),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GoodsSheetSectionHeader(context.tr("sort_by_barcode")),
          _buildOptions(
            SortByNumber.values.map(
              (item) => GoodsSheetChip(
                label: item.getText(context),
                isSelected: _sortByBarCode == item,
                onTap: () => setState(() => _sortByBarCode = item),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GoodsSheetSectionHeader(context.tr("sort_by_quantity")),
          _buildOptions(
            SortByNumber.values.map(
              (item) => GoodsSheetChip(
                label: item.getText(context),
                isSelected: _sortByQuantity == item,
                onTap: () => setState(() => _sortByQuantity = item),
              ),
            ),
          ),
          const SizedBox(height: 40),
          GoodsSheetActions(
            onResetAllPressed: widget.onResetAllPressed,
            onApplyPressed: () {
              widget.onApplyPressed(
                widget.setting.copyWith(
                  sortByName: _sortByName,
                  sortByBarcode: _sortByBarCode,
                  sortByQuantity: _sortByQuantity,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(Iterable<Widget> children) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: children.toList(),
    );
  }
}
