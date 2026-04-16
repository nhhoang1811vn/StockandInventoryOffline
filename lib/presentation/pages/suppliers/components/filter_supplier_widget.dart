import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';

import '../../../../domain/entity/entity.dart';
import '../../../widget/widget.dart';

class FilterSupplierWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(SuppliersSetting) onApplyPressed;
  final SuppliersSetting setting;

  FilterSupplierWidget({
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<FilterSupplierWidget> {
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
                    widget.setting.copyWith(sortByName: _sortByName),
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: SortByText.values
          .map(
            (item) => AppTextSelection(
              item: item.getText(context),
              isSelected: _sortByName == item,
              onPressed: () {
                setState(() {
                  _sortByName = item;
                });
              },
            ),
          )
          .toList(),
    );
  }
}
