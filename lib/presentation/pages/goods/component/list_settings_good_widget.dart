import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/entity.dart';
import 'goods_sheet_common.dart';

class ListSettingsGoodWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(GoodsSetting) onApplyPressed;
  final GoodsSetting setting;

  const ListSettingsGoodWidget({
    super.key,
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<ListSettingsGoodWidget> createState() => ListSettingsGoodWidgetState();
}

class ListSettingsGoodWidgetState extends State<ListSettingsGoodWidget> {
  late bool _hideZeroEntries;
  late bool _showBarcode;
  late bool _showDescription;
  late bool _showPurchasePrice;
  late PriceDisplayMode _purchaseDisplayMode;
  late bool _showSalePrice;
  late PriceDisplayMode _saleDisplayMode;
  late bool _showMinQuantity;
  late int _gridColumnCount;

  @override
  void initState() {
    super.initState();
    _hideZeroEntries = widget.setting.hideZeroEntries;
    _showBarcode = widget.setting.showBarcode;
    _showDescription = widget.setting.showDescription;
    _showPurchasePrice = widget.setting.showPurchasePrice;
    _purchaseDisplayMode = widget.setting.purchaseDisplayMode;
    _showSalePrice = widget.setting.showSalePrice;
    _saleDisplayMode = widget.setting.saleDisplayMode;
    _showMinQuantity = widget.setting.showMinQuantity;
    _gridColumnCount = widget.setting.gridColumnCount;
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
            title: context.tr("list_settings"),
            titleFontSize: 18,
          ),
          const SizedBox(height: 16),
          GoodsSheetSectionHeader(context.tr("display")),
          GoodsSheetSwitch(
            label: context.tr("good_settings_hide_zero_entries"),
            value: _hideZeroEntries,
            onChanged: (v) => setState(() => _hideZeroEntries = v),
          ),
          GoodsSheetSwitch(
            label: context.tr("good_setting_show_bar_code"),
            value: _showBarcode,
            onChanged: (v) => setState(() => _showBarcode = v),
          ),
          GoodsSheetSwitch(
            label: context.tr("good_setting_show_description"),
            value: _showDescription,
            onChanged: (v) => setState(() => _showDescription = v),
          ),
          GoodsSheetSwitch(
            label: context.tr("good_setting_show_purchase"),
            value: _showPurchasePrice,
            onChanged: (v) => setState(() => _showPurchasePrice = v),
          ),
          if (_showPurchasePrice)
            _buildDisplayModeRadios(
              value: _purchaseDisplayMode,
              onChanged: (v) => setState(() => _purchaseDisplayMode = v),
            ),
          GoodsSheetSwitch(
            label: context.tr("good_setting_show_price"),
            value: _showSalePrice,
            onChanged: (v) => setState(() => _showSalePrice = v),
          ),
          if (_showSalePrice)
            _buildDisplayModeRadios(
              value: _saleDisplayMode,
              onChanged: (v) => setState(() => _saleDisplayMode = v),
            ),
          GoodsSheetSwitch(
            label: context.tr("good_setting_show_min_quantity"),
            value: _showMinQuantity,
            onChanged: (v) => setState(() => _showMinQuantity = v),
          ),
          const SizedBox(height: 24),
          GoodsSheetSectionHeader(context.tr("good_setting_layout")),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              (1, context.tr("good_setting_layout_list")),
              (2, context.tr("good_setting_layout_2_columns")),
              (3, context.tr("good_setting_layout_3_columns")),
            ].map((option) {
              return GoodsSheetChip(
                label: option.$2,
                isSelected: _gridColumnCount == option.$1,
                onTap: () => setState(() => _gridColumnCount = option.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          GoodsSheetActions(
            onResetAllPressed: widget.onResetAllPressed,
            onApplyPressed: () {
              widget.onApplyPressed(
                widget.setting.copyWith(
                  hideZeroEntries: _hideZeroEntries,
                  showBarcode: _showBarcode,
                  showDescription: _showDescription,
                  showPurchasePrice: _showPurchasePrice,
                  purchaseDisplayMode: _purchaseDisplayMode,
                  showSalePrice: _showSalePrice,
                  saleDisplayMode: _saleDisplayMode,
                  showMinQuantity: _showMinQuantity,
                  gridColumnCount: _gridColumnCount,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayModeRadios({
    required PriceDisplayMode value,
    required ValueChanged<PriceDisplayMode> onChanged,
  }) {
    final theme = Theme.of(context);
    final titleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Column(
        children: [
          RadioListTile<PriceDisplayMode>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(context.tr("good_setting_display_price"),
                style: titleStyle),
            value: PriceDisplayMode.price,
            groupValue: value,
            activeColor: theme.colorScheme.primary,
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
          RadioListTile<PriceDisplayMode>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(context.tr("good_setting_display_amount"),
                style: titleStyle),
            value: PriceDisplayMode.amount,
            groupValue: value,
            activeColor: theme.colorScheme.primary,
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
