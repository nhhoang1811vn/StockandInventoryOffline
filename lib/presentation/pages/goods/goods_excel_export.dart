import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';

import '../../../domain/entity/entity.dart';
import 'component/excel_column_mapping.dart';
import 'goods_xlsx_writer.dart';

class GoodsExcelExportBuilder {
  static Uint8List build({
    required List<Good> goods,
    required ExcelColumnMapping mapping,
  }) {
    final rows = <List<GoodsXlsxCell>>[
      _headerRow(mapping),
      for (final good in goods) _dataRow(good, mapping),
    ];
    return GoodsXlsxWriter.write(rows);
  }

  static List<GoodsXlsxCell> _headerRow(ExcelColumnMapping mapping) {
    return [
      for (final field in ExcelImportField.values)
        if (mapping[field] != null)
          GoodsXlsxCell.text(mapping[field]!, _headerLabel(field)),
    ];
  }

  static List<GoodsXlsxCell> _dataRow(Good good, ExcelColumnMapping mapping) {
    final cells = <GoodsXlsxCell>[];
    _addText(cells, mapping, ExcelImportField.name, good.name);
    _addText(cells, mapping, ExcelImportField.description, good.description);
    _addText(cells, mapping, ExcelImportField.barcode, good.barCode);
    _addNumber(
        cells, mapping, ExcelImportField.purchasePrice, good.purchasePrice);
    _addNumber(cells, mapping, ExcelImportField.salePrice, good.salePrice);
    _addNumber(cells, mapping, ExcelImportField.minQuantity, good.minQuantity);
    return cells;
  }

  static void _addText(
    List<GoodsXlsxCell> cells,
    ExcelColumnMapping mapping,
    ExcelImportField field,
    String? value,
  ) {
    final column = mapping[field];
    if (column == null) return;
    cells.add(GoodsXlsxCell.text(column, value ?? ''));
  }

  static void _addNumber(
    List<GoodsXlsxCell> cells,
    ExcelColumnMapping mapping,
    ExcelImportField field,
    double? value,
  ) {
    final column = mapping[field];
    if (column == null || value == null) return;
    cells.add(GoodsXlsxCell.number(column, value));
  }

  static String _headerLabel(ExcelImportField field) {
    switch (field) {
      case ExcelImportField.name:
        return 'item_name'.tr();
      case ExcelImportField.description:
        return 'label_description'.tr();
      case ExcelImportField.barcode:
        return 'barcode'.tr();
      case ExcelImportField.purchasePrice:
        return 'purchase_price'.tr();
      case ExcelImportField.salePrice:
        return 'sale_price'.tr();
      case ExcelImportField.minQuantity:
        return 'min_quantity'.tr();
    }
  }
}
