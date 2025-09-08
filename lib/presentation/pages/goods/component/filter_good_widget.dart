import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';

import '../../../../domain/entity/entity.dart';
import '../../../widget/widget.dart';

class FilterGoodWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(GoodsSetting) onApplyPressed;
  final GoodsSetting setting;

  FilterGoodWidget({
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterGoodWidgetState();
  }
}

class FilterGoodWidgetState extends State<FilterGoodWidget> {
  //bool? _isPaid;
  SortByText _sortByName = SortByText.no_sort;
  SortByNumber _sortByBarCode = SortByNumber.no_sort;
  SortByNumber _sortByQuantity = SortByNumber.no_sort;

  @override
  void initState() {
    super.initState();
    _sortByName = widget.setting.sortByName;
    _sortByBarCode = widget.setting.sortByBarcode;
    _sortByQuantity = widget.setting.sortByQuantity;
    //_isPaid = widget.setting.isPaid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              context.tr("title_filter"),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 16),
          Text(
            context.tr("sort_by_name"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          buildSortByNameOptions(),
          SizedBox(height: 16),
          Text(
            context.tr("sort_by_barcode"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          buildSortByBarcodeOptions(),
          SizedBox(height: 16),
          Text(
            context.tr("sort_by_quantity"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          buildSortByQuantityOptions(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MyOutlineButton(
                    context.tr("action_reset_all"), () {
                  widget.onResetAllPressed();
                }),
              ),
              SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(context.tr("action_apply"),
                    () {
                  widget.onApplyPressed(
                    widget.setting.copyWith(
                      sortByName: _sortByName,
                      sortByBarcode: _sortByBarCode,
                      sortByQuantity: _sortByQuantity,
                      //    isPaid: _isPaid
                    ),
                  );
                }),
              ),
            ],
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
    return Wrap(spacing: 8, runSpacing: 8, children: items);
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
    return Wrap(spacing: 8, runSpacing: 8, children: items);
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
    return Wrap(spacing: 8, runSpacing: 8, children: items);
  }
}
