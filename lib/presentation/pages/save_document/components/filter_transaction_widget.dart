import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';

import '../../../../domain/entity/entity.dart';
import '../../../widget/widget.dart';

class FilterTransactionWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(SaveDocumentSetting setting) onApplyPressed;
  final SaveDocumentSetting setting;

  const FilterTransactionWidget({
    super.key,
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FilterSheetHeader(),
          FilterSectionTitle(context.tr("sort_by_name")),
          buildSortByNameOptions(),
          FilterSectionTitle(context.tr("sort_by_barcode")),
          buildSortByBarcodeOptions(),
          FilterSectionTitle(context.tr("sort_by_quantity")),
          buildSortByQuantityOptions(),
          FilterSheetActions(
            onReset: widget.onResetAllPressed,
            onApply: () {
              widget.onApplyPressed(
                widget.setting.copyWith(
                  sortByName: _sortByName,
                  sortByBarcode: _sortByBarCode,
                  sortByQuantity: _sortByQuantity,
                  //    isPaid: _isPaid
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSortByNameOptions() {
    List<Widget> items = [];
    for (var item in SortByText.values) {
      items.add(
        AppTextSelection(
          item: item.getText(context),
          isSelected: _sortByName == item,
          onPressed: () {
            setState(() {
              _sortByName = item;
            });
          },
        ),
      );
    }
    return FilterChipWrap(children: items);
  }

  Widget buildSortByBarcodeOptions() {
    List<Widget> items = [];
    for (var item in SortByNumber.values) {
      items.add(
        AppTextSelection(
          item: item.getText(context),
          isSelected: _sortByBarCode == item,
          onPressed: () {
            setState(() {
              _sortByBarCode = item;
            });
          },
        ),
      );
    }
    return FilterChipWrap(children: items);
  }

  Widget buildSortByQuantityOptions() {
    List<Widget> items = [];
    for (var item in SortByNumber.values) {
      items.add(
        AppTextSelection(
          item: item.getText(context),
          isSelected: _sortByQuantity == item,
          onPressed: () {
            setState(() {
              _sortByQuantity = item;
            });
          },
        ),
      );
    }
    return FilterChipWrap(children: items);
  }
}
