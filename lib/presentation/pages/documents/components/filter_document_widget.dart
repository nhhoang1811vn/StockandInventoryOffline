import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';
import 'package:good_manager/presentation/widget/widget.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';

class FilterDocumentWidget extends StatefulWidget {
  final Function() onResetAllPressed;
  final Function(DocumentsSetting) onApplyPressed;
  final DocumentsSetting setting;

  const FilterDocumentWidget({
    super.key,
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FilterSheetHeader(),
          if (AppSettings.getDocumentPropertiesSettings().showDateTime) ...[
            FilterSectionTitle(context.tr("sort_by_date")),
            buildSortByDateOptions(),
            SizedBox(height: 16),
          ],
          _buildByStatusWidget(),
          FilterSheetActions(
            onReset: widget.onResetAllPressed,
            onApply: () {
              widget.onApplyPressed(
                widget.setting.copyWith(
                  sortByDateNewestFirst: _sortByDateNewestFirst,
                  selectedStatus: _selectedStatus,
                  //    isPaid: _isPaid
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSortByDateOptions() {
    List<Widget> items = [];
    items.add(
      AppTextSelection(
        item: context.tr("newest_to_oldest"),
        isSelected: _sortByDateNewestFirst,
        onPressed: () {
          setState(() {
            _sortByDateNewestFirst = true;
          });
        },
      ),
    );
    items.add(
      AppTextSelection(
        item: context.tr("oldest_to_newest"),
        isSelected: !_sortByDateNewestFirst,
        onPressed: () {
          setState(() {
            _sortByDateNewestFirst = false;
          });
        },
      ),
    );
    return FilterChipWrap(children: items);
  }

  Widget _buildByStatusWidget() {
    List<Widget> items = [];
    items.add(
      AppTextSelection(
        item: context.tr("show_all"),
        isSelected: _selectedStatus.isEmpty,
        onPressed: () {
          setState(() {
            _selectedStatus = {};
          });
        },
      ),
    );
    for (var status in DocumentPaidStatus.values) {
      items.add(
        AppTextSelection(
          item: status.getText(context),
          isSelected: _selectedStatus.contains(status),
          onPressed: () {
            setState(() {
              if (_selectedStatus.contains(status)) {
                _selectedStatus.remove(status);
              } else {
                _selectedStatus.add(status);
              }
            });
          },
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionTitle(context.tr("by_status")),
        FilterChipWrap(children: items),
      ],
    );
  }
}
