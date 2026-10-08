import 'dart:typed_data';

import 'package:archive/archive.dart';

class GoodsXlsxCell {
  final int column;
  final String? text;
  final num? number;

  const GoodsXlsxCell.text(this.column, this.text) : number = null;

  const GoodsXlsxCell.number(this.column, this.number) : text = null;
}

/// Builds a single-sheet .xlsx workbook using OOXML.
class GoodsXlsxWriter {
  static Uint8List write(List<List<GoodsXlsxCell>> rows) {
    final archive = Archive()
      ..add(ArchiveFile.string('[Content_Types].xml', _contentTypes))
      ..add(ArchiveFile.string('_rels/.rels', _rels))
      ..add(ArchiveFile.string('xl/workbook.xml', _workbook))
      ..add(ArchiveFile.string('xl/_rels/workbook.xml.rels', _workbookRels))
      ..add(ArchiveFile.string('xl/worksheets/sheet1.xml', _sheetXml(rows)));
    return ZipEncoder().encodeBytes(archive);
  }

  static String _sheetXml(List<List<GoodsXlsxCell>> rows) {
    final buffer = StringBuffer()
      ..write(
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
        '<sheetData>',
      );

    for (var r = 0; r < rows.length; r++) {
      final rowNumber = r + 1;
      final cells = [...rows[r]]..sort((a, b) => a.column.compareTo(b.column));
      buffer.write('<row r="$rowNumber">');
      for (final cell in cells) {
        final ref = '${_columnLetter(cell.column)}$rowNumber';
        if (cell.number != null) {
          buffer.write('<c r="$ref"><v>${_numberXml(cell.number!)}</v></c>');
        } else {
          final text = _sanitizeText(cell.text ?? '');
          final space = text != text.trim() ? ' xml:space="preserve"' : '';
          buffer.write(
            '<c r="$ref" t="inlineStr"><is><t$space>${_xmlEscape(text)}</t></is></c>',
          );
        }
      }
      buffer.write('</row>');
    }

    buffer.write('</sheetData></worksheet>');
    return buffer.toString();
  }

  static String _columnLetter(int index) {
    var n = index;
    final letters = StringBuffer();
    do {
      letters.writeCharCode(65 + (n % 26));
      n = n ~/ 26 - 1;
    } while (n >= 0);
    return letters.toString().split('').reversed.join();
  }

  static String _numberXml(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toString();
  }

  static String _sanitizeText(String value) {
    return value.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '');
  }

  static String _xmlEscape(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }

  static const _contentTypes =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '</Types>';

  static const _rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
      '</Relationships>';

  static const _workbook =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
      'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
      '<sheets><sheet name="Goods" sheetId="1" r:id="rId1"/></sheets>'
      '</workbook>';

  static const _workbookRels =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
      '</Relationships>';
}
