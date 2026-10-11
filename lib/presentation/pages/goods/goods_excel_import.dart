import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';

import 'component/excel_column_mapping.dart';
import 'goods_xlsx_reader.dart';

class GoodsExcelImportParser {
  static List<ImportedGoodRow> parse({
    required Uint8List bytes,
    required String? fileName,
    required ExcelColumnMapping mapping,
  }) {
    final rows = _readRows(bytes, fileName: fileName);
    if (rows.isEmpty) return const [];

    final startIndex = _isHeaderRow(rows.first, mapping) ? 1 : 0;
    final results = <ImportedGoodRow>[];

    for (var i = startIndex; i < rows.length; i++) {
      final row = rows[i];
      final name = _cell(row, mapping[ExcelImportField.name]).trim();
      if (name.isEmpty) continue;

      results.add(
        ImportedGoodRow(
          name: name,
          description:
              _optional(_cell(row, mapping[ExcelImportField.description])),
          barcode: _barcode(_cell(row, mapping[ExcelImportField.barcode])),
          purchasePrice: _parseNumber(
            _cell(row, mapping[ExcelImportField.purchasePrice]),
          ),
          salePrice: _parseNumber(
            _cell(row, mapping[ExcelImportField.salePrice]),
          ),
          minQuantity: _parseNumber(
            _cell(row, mapping[ExcelImportField.minQuantity]),
          ),
        ),
      );
    }
    return results;
  }

  static List<List<String>> _readRows(Uint8List bytes, {String? fileName}) {
    final lowerName = (fileName ?? '').toLowerCase();
    if (lowerName.endsWith('.csv')) {
      return _readCsv(bytes);
    }
    try {
      return _readXlsx(bytes);
    } catch (_) {
      return _readCsv(bytes);
    }
  }

  static List<List<String>> _readCsv(Uint8List bytes) {
    var content = utf8.decode(bytes, allowMalformed: true);
    if (content.startsWith('\uFEFF')) {
      content = content.substring(1);
    }
    final rows = Csv().decode(content);
    return rows
        .map((row) => row.map((cell) => cell?.toString() ?? '').toList())
        .toList();
  }

  static List<List<String>> _readXlsx(Uint8List bytes) {
    return GoodsXlsxReader.read(bytes);
  }

  static bool _isHeaderRow(
    List<String> row,
    ExcelColumnMapping mapping,
  ) {
    final name =
        _cell(row, mapping[ExcelImportField.name]).trim().toLowerCase();
    if (name.isEmpty) return true;
    final aliases = {
      'name',
      'item name',
      'item_name',
      'good name',
      'good_name',
      'item_name'.tr().toLowerCase(),
      'name'.tr().toLowerCase(),
      'label_good_name'.tr().toLowerCase(),
    };
    return aliases.contains(name);
  }

  static String _cell(List<String> row, int? index) {
    if (index == null || index < 0 || index >= row.length) return '';
    return row[index];
  }

  static String? _optional(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  /// Barcode is always stored as text. Excel numeric cells often arrive as
  /// "1.0" or scientific notation; keep the digit string the user sees.
  static String? _barcode(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;

    final trailingZeros = RegExp(r'^([+-]?\d+)\.0+$').firstMatch(text);
    if (trailingZeros != null) {
      return trailingZeros.group(1);
    }

    if (RegExp(r'^[+-]?\d+(\.\d+)?[eE][+-]?\d+$').hasMatch(text)) {
      final number = num.tryParse(text);
      if (number != null &&
          number % 1 == 0 &&
          number.abs() <= 9007199254740991) {
        return number.toInt().toString();
      }
    }

    return text;
  }

  static double? _parseNumber(String value) {
    var text = value.trim();
    if (text.isEmpty) return null;
    text = text.replaceAll(RegExp(r'[^0-9,.\-]'), '');
    if (text.contains(',') && text.contains('.')) {
      text = text.replaceAll(',', '');
    } else if (text.contains(',')) {
      text = text.replaceAll(',', '.');
    }
    return double.tryParse(text);
  }
}
