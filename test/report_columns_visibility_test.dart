import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/domain/entity/entity.dart';

void main() {
  final columns = [
    ColumnInfo("name"),
    ColumnInfo("barcode", visibleWhen: ColumnGate.barcode),
    ColumnInfo("amount", visibleWhen: ColumnGate.purchasePrice),
    ColumnInfo("quantity"),
  ];
  final rows = [
    MapEntry(1, ["a", "111", "5", "2"]),
    MapEntry(2, ["b", "222", "6", "3"]),
  ];

  test('keeps every column when all properties are shown', () {
    final r = applyColumnVisibility(columns, rows, GoodPropertiesSettings());
    expect(r.columns.map((c) => c.name),
        ["name", "barcode", "amount", "quantity"]);
    expect(r.rows[0].value, ["a", "111", "5", "2"]);
  });

  test('drops gated columns and the matching cells, keeping row keys', () {
    final r = applyColumnVisibility(columns, rows,
        GoodPropertiesSettings(showBarcode: false, showPurchasePrice: false));
    expect(r.columns.map((c) => c.name), ["name", "quantity"]);
    expect(r.rows.map((e) => e.key), [1, 2]);
    expect(r.rows[0].value, ["a", "2"]);
    expect(r.rows[1].value, ["b", "3"]);
  });

  group('gates', () {
    test('profit needs both prices', () {
      expect(ColumnGate.bothPrices(GoodPropertiesSettings()), isTrue);
      expect(
          ColumnGate.bothPrices(GoodPropertiesSettings(showSalePrice: false)),
          isFalse);
      expect(
          ColumnGate.bothPrices(
              GoodPropertiesSettings(showPurchasePrice: false)),
          isFalse);
    });

    test('documentAmount needs the price of every document type', () {
      expect(ColumnGate.documentAmount(GoodPropertiesSettings()), isTrue);
      expect(
          ColumnGate.documentAmount(
              GoodPropertiesSettings(showPurchasePrice: false)),
          isFalse);
    });

    test('forDocumentType follows the type', () {
      final gate = ColumnGate.forDocumentType(DocumentType.outgoing);
      expect(gate(GoodPropertiesSettings(showPurchasePrice: false)), isTrue);
      expect(gate(GoodPropertiesSettings(showSalePrice: false)), isFalse);
    });
  });
}
