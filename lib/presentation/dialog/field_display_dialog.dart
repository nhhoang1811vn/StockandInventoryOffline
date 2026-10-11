import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';

class ColumnDisplayDialog extends StatefulWidget {
  final List<ColumnReport> columns;
  const ColumnDisplayDialog({super.key, required this.columns});

  @override
  State<ColumnDisplayDialog> createState() => ColumnDisplayDialogState();
}

class ColumnDisplayDialogState extends State<ColumnDisplayDialog> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildPickableContent(PickableColumn column) {
    final allValues = column.values.toList();
    allValues.sort(); // Sort alphabetically for better UX

    final isAllSelected = column.selectedValues.length == allValues.length;
    final hasSelection = column.selectedValues.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            dense: true,
            tristate: hasSelection && !isAllSelected,
            value: isAllSelected ? true : (hasSelection ? null : false),
            title: Text(
              context.tr("all"),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onChanged: (_) {
              setState(() {
                if (isAllSelected) {
                  column.selectedValues.clear();
                } else {
                  column.selectedValues.addAll(column.values);
                }
              });
            },
          ),
          const Divider(height: 1),
          ...allValues.map((value) {
            return CheckboxListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              value: column.selectedValues.contains(value),
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked == true) {
                    column.selectedValues.add(value);
                  } else {
                    column.selectedValues.remove(value);
                  }
                });
              },
              title: Text(value, style: const TextStyle(fontSize: 14)),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr("settings")),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.columns.map((column) {
              return Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      context.tr(column.title),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    value: column.isVisible,
                    onChanged: (bool value) {
                      setState(() {
                        column.isVisible = value;
                      });
                    },
                  ),
                  if (column.isVisible && column is PickableColumn)
                    _buildPickableContent(column),
                  const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(context.tr("cancel")),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(context.tr("ok")),
          onPressed: () {
            Navigator.of(context).pop(widget.columns);
          },
        ),
      ],
    );
  }
}
