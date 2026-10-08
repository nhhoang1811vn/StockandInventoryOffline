import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/goods/component/goods_sheet_common.dart';

import '../../../../domain/entity/entity.dart';

class FilterDocumentWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(DocumentsSetting) onApplyPressed;
  final DocumentsSetting setting;

  FilterDocumentWidget({
    required this.onResetAllPressed,
    required this.onApplyPressed,
    required this.setting,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterDocumentWidgetState();
  }
}

class FilterDocumentWidgetState extends State<FilterDocumentWidget> {
  Set<DocumentPaidStatus> _selectedStatus = {};
  bool _sortByDateNewestFirst = true;

  @override
  void initState() {
    super.initState();
    _sortByDateNewestFirst = widget.setting.sortByDateNewestFirst;
    _selectedStatus = Set<DocumentPaidStatus>.of(widget.setting.selectedStatus);
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
          GoodsSheetSectionHeader(context.tr("sort_by_date")),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              GoodsSheetChip(
                label: context.tr("newest_to_oldest"),
                isSelected: _sortByDateNewestFirst,
                onTap: () => setState(() => _sortByDateNewestFirst = true),
              ),
              GoodsSheetChip(
                label: context.tr("oldest_to_newest"),
                isSelected: !_sortByDateNewestFirst,
                onTap: () => setState(() => _sortByDateNewestFirst = false),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GoodsSheetSectionHeader(context.tr("by_status")),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              GoodsSheetChip(
                label: context.tr("show_all"),
                isSelected: _selectedStatus.isEmpty,
                onTap: () => setState(() => _selectedStatus = {}),
              ),
              ...DocumentPaidStatus.values.map(
                (status) => GoodsSheetChip(
                  label: status.getText(context),
                  isSelected: _selectedStatus.contains(status),
                  onTap: () {
                    setState(() {
                      if (_selectedStatus.contains(status)) {
                        _selectedStatus.remove(status);
                      } else {
                        _selectedStatus.add(status);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          GoodsSheetActions(
            onResetAllPressed: widget.onResetAllPressed,
            onApplyPressed: () {
              widget.onApplyPressed(
                widget.setting.copyWith(
                  sortByDateNewestFirst: _sortByDateNewestFirst,
                  selectedStatus: _selectedStatus,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
