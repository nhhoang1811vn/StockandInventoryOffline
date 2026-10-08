import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

enum ExcelImportField {
  name,
  description,
  barcode,
  purchasePrice,
  salePrice,
  minQuantity,
}

class ExcelColumnChoice {
  final int? index;

  const ExcelColumnChoice.unused() : index = null;

  const ExcelColumnChoice.column(this.index);
}

class ExcelColumnMapping {
  ExcelColumnMapping(Map<ExcelImportField, int?> columns)
      : columns = Map<ExcelImportField, int?>.from(columns);

  final Map<ExcelImportField, int?> columns;

  factory ExcelColumnMapping.defaults() => ExcelColumnMapping({
        ExcelImportField.name: 0,
        ExcelImportField.description: 1,
        ExcelImportField.barcode: 2,
        ExcelImportField.purchasePrice: 3,
        ExcelImportField.salePrice: 4,
        ExcelImportField.minQuantity: 5,
      });

  int? operator [](ExcelImportField field) => columns[field];

  void operator []=(ExcelImportField field, int? column) {
    columns[field] = column;
  }

  bool get hasNameColumn => columns[ExcelImportField.name] != null;

  Set<int> usedColumnsExcept(ExcelImportField field) {
    return columns.entries
        .where((entry) => entry.key != field && entry.value != null)
        .map((entry) => entry.value!)
        .toSet();
  }

  static String letterOf(int index) => String.fromCharCode(65 + index);

  static String displayOf(int? index) => index == null ? '-' : letterOf(index);
}

extension ExcelImportFieldLabel on ExcelImportField {
  String label(BuildContext context) {
    switch (this) {
      case ExcelImportField.name:
        return context.tr("item_name");
      case ExcelImportField.description:
        return context.tr("label_description");
      case ExcelImportField.barcode:
        return context.tr("barcode");
      case ExcelImportField.purchasePrice:
        return context.tr("purchase_price");
      case ExcelImportField.salePrice:
        return context.tr("sale_price");
      case ExcelImportField.minQuantity:
        return context.tr("min_quantity");
    }
  }
}

class ImportedGoodRow {
  final String name;
  final String? description;
  final String? barcode;
  final double? purchasePrice;
  final double? salePrice;
  final double? minQuantity;

  const ImportedGoodRow({
    required this.name,
    this.description,
    this.barcode,
    this.purchasePrice,
    this.salePrice,
    this.minQuantity,
  });
}
