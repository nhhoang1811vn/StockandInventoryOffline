import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/payment/components/text_selection.dart';
import 'package:good_manager/presentation/widget/widget.dart';

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
            context.tr("sort_by_date"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          buildSortByDateOptions(),
          SizedBox(height: 16),
          _buildByStatusWidget(),
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
                      sortByDateNewestFirst: _sortByDateNewestFirst,
                      selectedStatus: _selectedStatus,
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
    return Wrap(spacing: 8, runSpacing: 8, children: items);
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
        Text(
          context.tr("by_status"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: items),
      ],
    );
  }
}
