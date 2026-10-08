import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// Reads the first worksheet of an .xlsx file into a grid of cell strings.
class GoodsXlsxReader {
  static List<List<String>> read(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final files = <String, ArchiveFile>{};
    for (final file in archive) {
      files[file.name.replaceAll('\\', '/')] = file;
    }

    final sharedStrings = _parseSharedStrings(
      _decode(files['xl/sharedStrings.xml']),
    );
    final sheetXml = _firstSheetXml(files);
    if (sheetXml == null) return const [];
    return _parseSheet(sheetXml, sharedStrings);
  }

  static String? _decode(ArchiveFile? file) {
    if (file == null) return null;
    return utf8.decode(file.content, allowMalformed: true);
  }

  static String? _firstSheetXml(Map<String, ArchiveFile> files) {
    final sheet1 = files['xl/worksheets/sheet1.xml'];
    if (sheet1 != null) return _decode(sheet1);

    for (final entry in files.entries) {
      final name = entry.key.toLowerCase();
      if (name.startsWith('xl/worksheets/sheet') && name.endsWith('.xml')) {
        return _decode(entry.value);
      }
    }
    return null;
  }

  static List<String> _parseSharedStrings(String? xml) {
    if (xml == null || xml.isEmpty) return const [];
    final doc = XmlDocument.parse(xml);
    return doc.findAllElements('si').map(_plainText).toList();
  }

  static List<List<String>> _parseSheet(
    String xml,
    List<String> sharedStrings,
  ) {
    final doc = XmlDocument.parse(xml);
    final rows = <List<String>>[];

    for (final row in doc.findAllElements('row')) {
      final cells = <int, String>{};
      var maxIndex = -1;

      for (final cell in row.findElements('c')) {
        final ref = cell.getAttribute('r');
        final index = ref == null ? maxIndex + 1 : _columnIndex(ref);
        if (index < 0) continue;
        maxIndex = index > maxIndex ? index : maxIndex;
        cells[index] = _cellValue(cell, sharedStrings);
      }

      if (maxIndex < 0) {
        rows.add(const []);
        continue;
      }
      rows.add(List<String>.generate(maxIndex + 1, (i) => cells[i] ?? ''));
    }
    return rows;
  }

  static String _cellValue(XmlElement cell, List<String> sharedStrings) {
    final type = cell.getAttribute('t');
    if (type == 'inlineStr') {
      return _plainText(cell);
    }
    final value = cell.getElement('v')?.innerText ?? '';
    if (type == 's') {
      final index = int.tryParse(value);
      if (index == null || index < 0 || index >= sharedStrings.length) {
        return '';
      }
      return sharedStrings[index];
    }
    if (type == 'b') {
      return value == '1' || value.toLowerCase() == 'true' ? 'true' : 'false';
    }
    // Numeric cells (no type, or t="n") are stored as 1.0 / 1E+0 in OOXML.
    if (type == null || type == 'n') {
      return _formatNumericValue(value);
    }
    return value;
  }

  /// Keeps barcodes and other whole numbers as "1" instead of "1.0".
  static String _formatNumericValue(String raw) {
    if (raw.isEmpty) return raw;
    final number = num.tryParse(raw);
    if (number == null) return raw;
    if (number % 1 != 0) return raw;
    if (number.abs() > 9007199254740991) return raw;
    return number.toInt().toString();
  }

  static String _plainText(XmlElement node) {
    return node.findAllElements('t').map((e) => e.innerText).join();
  }

  static int _columnIndex(String cellRef) {
    var index = 0;
    for (final code in cellRef.codeUnits) {
      if (code < 65 || code > 90) break;
      index = index * 26 + (code - 64);
    }
    return index - 1;
  }
}
