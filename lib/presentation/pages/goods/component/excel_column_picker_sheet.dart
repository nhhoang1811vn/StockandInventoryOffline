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
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 8, 8),
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
                    tooltip: context.tr('a11y_close'),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RadioGroup<int>(
                groupValue: selectedColumn ?? -1,
                onChanged: (int? value) {
                  if (value == null) return;
                  if (value == -1) {
                    Navigator.pop(
                      context,
                      const ExcelColumnChoice.unused(),
                    );
                    return;
                  }
                  if (usedColumns.contains(value)) return;
                  Navigator.pop(context, ExcelColumnChoice.column(value));
                },
                child: ListView(
                  children: [
                    RadioListTile<int>(
                      title: Text(context.tr("excel_column_unused")),
                      value: -1,
                    ),
                    for (var i = 0; i < 26; i++)
                      _buildColumnTile(context, theme, i),
                  ],
                ),
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
      enabled: !isTaken,
    );
  }
}
