import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../../../../domain/entity/entity.dart';

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

  /// Fields shown for a Store, in enum order. Name is always shown; the
  /// others follow their Good property.
  static List<ExcelImportField> visibleFields(GoodPropertiesSettings p) {
    return [
      for (final field in ExcelImportField.values)
        if (_isVisible(field, p)) field,
    ];
  }

  static bool _isVisible(ExcelImportField field, GoodPropertiesSettings p) {
    switch (field) {
      case ExcelImportField.description:
        return p.showDescription;
      case ExcelImportField.barcode:
        return p.showBarcode;
      case ExcelImportField.minQuantity:
        return p.showMinQuantity;
      case ExcelImportField.purchasePrice:
        return p.showPurchasePrice;
      case ExcelImportField.salePrice:
        return p.showSalePrice;
      case ExcelImportField.name:
        return true;
    }
  }

  /// Hidden fields are unmapped (`null`). By default visible fields keep
  /// their standard column (so a file exported with every property shown still
  /// imports correctly). With [compact] (used for export) visible fields are
  /// packed from column A with no gap.
  factory ExcelColumnMapping.defaults({
    GoodPropertiesSettings? properties,
    bool compact = false,
  }) {
    final visible = visibleFields(properties ?? GoodPropertiesSettings());
    return ExcelColumnMapping({
      for (final field in ExcelImportField.values)
        field: !visible.contains(field)
            ? null
            : (compact ? visible.indexOf(field) : field.index),
    });
  }

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
