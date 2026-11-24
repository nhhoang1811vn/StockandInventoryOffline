import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/save_document/document_table_builder.dart';

DocumentTransaction _tx(String name, double qty, double? price) {
  final good = Good()
    ..name = name
    ..description = 'desc $name'
    ..barCode = 'bc $name';
  return DocumentTransaction()
    ..good = good
    ..quantity = qty
    ..price = price
    ..type = DocumentType.incoming;
}

String _tr(String key) => key;

void main() {
  final txs = [_tx('A', 2, 5), _tx('B', 1, 10)];

  test('all properties shown keeps every column and the totals', () {
    final t = buildDocumentTable(
      transactions: txs,
      type: DocumentType.incoming,
      properties: GoodPropertiesSettings(),
      tr: _tr,
    );
    expect(t[0], [
      'name',
      'label_description',
      'barcode',
      'price',
      'quantity',
      'amount'
    ]);
    expect(t[1], ['A', 'desc A', 'bc A', '5.0', '2', '10.0']);
    expect(t.last, ['total', '', '', '', '3', '20.0']);
  });

  test('hidden description and barcode drop their columns', () {
    final t = buildDocumentTable(
      transactions: txs,
      type: DocumentType.incoming,
      properties:
          GoodPropertiesSettings(showDescription: false, showBarcode: false),
      tr: _tr,
    );
    expect(t[0], ['name', 'price', 'quantity', 'amount']);
    expect(t[1], ['A', '5.0', '2', '10.0']);
    expect(t.last, ['total', '', '3', '20.0']);
  });

  test('hidden price for the document type drops price and amount', () {
    final t = buildDocumentTable(
      transactions: txs,
      type: DocumentType.incoming,
      properties: GoodPropertiesSettings(showPurchasePrice: false),
      tr: _tr,
    );
    expect(t[0], ['name', 'label_description', 'barcode', 'quantity']);
    expect(t[1], ['A', 'desc A', 'bc A', '2']);
    expect(t.last, ['total', '', '', '3']);
  });

  test('quantities follow the number of decimals', () {
    final t = buildDocumentTable(
      transactions: [_tx('A', 2.26, 5), _tx('B', 1.25, 10)],
      type: DocumentType.incoming,
      properties: GoodPropertiesSettings(),
      quantityDecimals: 1,
      tr: _tr,
    );
    expect(t[1][4], '2.3');
    expect(t[2][4], '1.3');
    expect(t.last[4], '3.5');
  });

  test('default is 2 decimals so existing fractions are kept', () {
    final t = buildDocumentTable(
      transactions: [_tx('A', 2.25, 5)],
      type: DocumentType.incoming,
      properties: GoodPropertiesSettings(),
      tr: _tr,
    );
    expect(t[1][4], '2.25');
  });

  test('the other price does not affect this document type', () {
    final t = buildDocumentTable(
      transactions: txs,
      type: DocumentType.incoming,
      properties: GoodPropertiesSettings(showSalePrice: false),
      tr: _tr,
    );
    expect(t[0], contains('amount'));
  });
}
