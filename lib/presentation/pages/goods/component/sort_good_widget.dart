import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import 'goods_sheet_common.dart';

class SortGoodWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(GoodsSetting) onApplyPressed;
  final GoodsSetting setting;

  const SortGoodWidget({
    super.key,
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<SortGoodWidget> createState() => SortGoodWidgetState();
}

class SortGoodWidgetState extends State<SortGoodWidget> {
  late SortByText _sortByName;
  late SortByNumber _sortByBarCode;
  late SortByNumber _sortByQuantity;
  late final GoodPropertiesSettings _properties;

  @override
  void initState() {
    super.initState();
    _properties = AppSettings.getGoodPropertiesSettings();
    _sortByName = widget.setting.sortByName;
    _sortByBarCode = widget.setting.sortByBarcode;
    _sortByQuantity = widget.setting.sortByQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GoodsSheetHeader(
            title: context.tr("action_sort_by"),
            titleFontSize: 18,
          ),
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
          if (_properties.showBarcode) ...[
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
          ],
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
