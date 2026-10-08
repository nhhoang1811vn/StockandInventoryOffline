import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'excel_column_mapping.dart';

Future<ExcelColumnChoice?> showExcelColumnPickerSheet({
  required BuildContext context,
  required ExcelImportField field,
  required int? selectedColumn,
  required Set<int> usedColumns,
}) {
  return showModalBottomSheet<ExcelColumnChoice>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) {
      return ExcelColumnPickerSheet(
        field: field,
        selectedColumn: selectedColumn,
        usedColumns: usedColumns,
      );
    },
  );
}

class ExcelColumnPickerSheet extends StatelessWidget {
  final ExcelImportField field;
  final int? selectedColumn;
  final Set<int> usedColumns;

  const ExcelColumnPickerSheet({
    super.key,
    required this.field,
    required this.selectedColumn,
    required this.usedColumns,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.sizeOf(context).height * 0.7;

    return SafeArea(
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      field.label(context),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  RadioListTile<int>(
                    title: Text(context.tr("excel_column_unused")),
                    value: -1,
                    groupValue: selectedColumn ?? -1,
                    onChanged: (_) {
                      Navigator.pop(
                        context,
                        const ExcelColumnChoice.unused(),
                      );
                    },
                  ),
                  for (var i = 0; i < 26; i++)
                    _buildColumnTile(context, theme, i),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnTile(BuildContext context, ThemeData theme, int index) {
    final isTaken = usedColumns.contains(index);
    final letter = ExcelColumnMapping.letterOf(index);
    return RadioListTile<int>(
      title: Text(
        letter,
        style: TextStyle(
          color: isTaken ? Colors.red : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: index,
      groupValue: selectedColumn ?? -1,
      onChanged: isTaken
          ? null
          : (_) {
              Navigator.pop(context, ExcelColumnChoice.column(index));
            },
    );
  }
}
