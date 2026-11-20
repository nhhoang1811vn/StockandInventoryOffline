import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/report_data/sales_by_item_rows.dart';
import 'package:good_manager/domain/entity/entity.dart';

Good good(int id, String name, {double? purchasePrice}) {
  return Good()
    ..id = id
    ..name = name
    ..purchasePrice = purchasePrice;
}

Document doc(int id, [DocumentType type = DocumentType.outgoing]) {
  return Document()
    ..id = id
    ..type = type;
}

DocumentTransaction tx(int documentId, int goodId, double quantity, double? price) {
  return DocumentTransaction()
    ..documentId = documentId
    ..goodId = goodId
    ..quantity = quantity
    ..price = price;
}

void main() {
  test('sums per good and lists zero-sale goods', () {
    final rows = buildSalesByItemRows(
      goods: [
        good(1, 'A', purchasePrice: 4),
        good(2, 'B'),
        good(3, 'C'),
      ],
      documents: [doc(1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10), tx(1, 2, 1, 5)],
      },
    );
    expect(rows.length, 3);
    expect(rows[0].good.name, 'A');
    expect(rows[0].quantity, 2);
    expect(rows[0].amount, 20);
    expect(rows[0].cost, 8);
    expect(rows[0].profit, 12);
    expect(rows[1].amount, 5);
    expect(rows[1].cost, 0);
    expect(rows[1].profit, 5);
    expect(rows[2].quantity, 0);
    expect(rows[2].amount, 0);
    expect(rows[2].cost, 0);
  });

  test('ignores lines of goods not in the list', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'A', purchasePrice: 4)],
      documents: [doc(1)],
      transactionsByDocumentId: {
        1: [tx(1, 99, 5, 10), tx(1, 1, 1, 10)],
      },
    );
    expect(rows.length, 1);
    expect(rows.single.quantity, 1);
  });

  test('ignores incoming documents', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'A', purchasePrice: 4)],
      documents: [doc(1, DocumentType.incoming)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 5, 10)],
      },
    );
    expect(rows.single.quantity, 0);
    expect(rows.single.amount, 0);
  });

  test('aggregates the same good across documents', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'A', purchasePrice: 4)],
      documents: [doc(1), doc(2)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 2, 10)],
      },
    );
    expect(rows.single.quantity, 3);
    expect(rows.single.amount, 30);
    expect(rows.single.cost, 12);
  });

  test('null transaction price counts as zero amount', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'A', purchasePrice: 3)],
      documents: [doc(1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, null)],
      },
    );
    expect(rows.single.amount, 0);
    expect(rows.single.cost, 6);
  });

  test('sorted by name case-insensitive', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'b'), good(2, 'A'), good(3, 'C')],
      documents: [],
      transactionsByDocumentId: {},
    );
    expect(rows.map((r) => r.good.name).toList(), ['A', 'b', 'C']);
  });

  test('same name goods stay separate rows', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'X'), good(2, 'X')],
      documents: [],
      transactionsByDocumentId: {},
    );
    final table = salesByItemTableRows(rows);
    expect(table.length, 2);
    expect(table.map((e) => e.key).toSet(), {1, 2});
  });

  test('empty goods gives empty rows', () {
    final rows = buildSalesByItemRows(
      goods: [],
      documents: [doc(1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
      },
    );
    expect(rows, isEmpty);
    expect(salesByItemTableRows(rows), isEmpty);
  });

  test('negative profit formats with minus', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'A', purchasePrice: 1300)],
      documents: [doc(1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 100)],
      },
    );
    expect(salesByItemTableRows(rows).single.value[4], '-1,200');
  });

  test('table row key and cells', () {
    final rows = buildSalesByItemRows(
      goods: [good(1, 'A', purchasePrice: 4)],
      documents: [doc(1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10)],
      },
    );
    final table = salesByItemTableRows(rows);
    expect(table.single.key, 1);
    expect(table.single.value, ['A', '2', '20', '8', '12']);
  });
}
