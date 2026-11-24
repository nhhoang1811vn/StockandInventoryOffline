import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import 'excel_column_mapping.dart';
import 'excel_column_picker_sheet.dart';

Future<ExcelColumnMapping?> showExcelColumnMappingSheet(
  BuildContext context, {
  bool allowAdjustColumns = true,
}) {
  return showModalBottomSheet<ExcelColumnMapping>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) => ExcelColumnMappingSheet(
      allowAdjustColumns: allowAdjustColumns,
    ),
  );
}

class ExcelColumnMappingSheet extends StatefulWidget {
  final bool allowAdjustColumns;

  const ExcelColumnMappingSheet({
    super.key,
    this.allowAdjustColumns = true,
  });

  @override
  State<ExcelColumnMappingSheet> createState() =>
      ExcelColumnMappingSheetState();
}

class ExcelColumnMappingSheetState extends State<ExcelColumnMappingSheet> {
  late final GoodPropertiesSettings _properties =
      AppSettings.getGoodPropertiesSettings();
  late final ExcelColumnMapping _mapping = ExcelColumnMapping.defaults(
    properties: _properties,
    compact: !widget.allowAdjustColumns,
  );

  Future<void> _pickColumn(ExcelImportField field) async {
    if (!widget.allowAdjustColumns) return;
    final choice = await showExcelColumnPickerSheet(
      context: context,
      field: field,
      selectedColumn: _mapping[field],
      usedColumns: _mapping.usedColumnsExcept(field),
    );
    if (choice == null || !mounted) return;
    setState(() => _mapping[field] = choice.index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr("excel_file_column"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            for (final field in ExcelColumnMapping.visibleFields(_properties))
              _buildFieldRow(theme, field),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      context.tr("cancel"),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _mapping.hasNameColumn
                        ? () => Navigator.pop(context, _mapping)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      context.tr("ok"),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(ThemeData theme, ExcelImportField field) {
    return InkWell(
      onTap: widget.allowAdjustColumns ? () => _pickColumn(field) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                field.label(context),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Text(
              ExcelColumnMapping.displayOf(_mapping[field]),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
