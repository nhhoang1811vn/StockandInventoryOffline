import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/report_data/sales_by_date_rows.dart';
import 'package:good_manager/domain/entity/entity.dart';

Document doc(int id, DateTime date, [DocumentType type = DocumentType.outgoing]) {
  return Document()
    ..id = id
    ..date = date
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
  final nov10 = DateTime(2026, 11, 10, 9);

  test('sums one outgoing day', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, nov10)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10), tx(1, 2, 1, 5)],
      },
      purchasePriceByGoodId: {1: 4, 2: null},
    );
    expect(rows.length, 1);
    expect(rows.first.quantity, 3);
    expect(rows.first.amount, 25);
    expect(rows.first.cost, 8);
    expect(rows.first.profit, 17);
  });

  test('empty days appear with zeros, newest first', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 8),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, DateTime(2026, 11, 9, 12))],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows.map((r) => r.day.day).toList(), [10, 9, 8]);
    expect(rows[0].amount, 0);
    expect(rows[1].amount, 10);
    expect(rows[2].quantity, 0);
  });

  test('ignores incoming documents', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, nov10, DocumentType.incoming)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 5, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows.single.quantity, 0);
    expect(rows.single.amount, 0);
    expect(rows.single.cost, 0);
  });

  test('last day includes 23:59 and excludes next-day 00:00', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [
        doc(1, DateTime(2026, 11, 10, 23, 59)),
        doc(2, DateTime(2026, 11, 11)),
      ],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 100, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows.length, 1);
    expect(rows.single.quantity, 1);
  });

  test('unknown good gives zero cost', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, nov10)],
      transactionsByDocumentId: {
        1: [tx(1, 99, 2, 10)],
      },
      purchasePriceByGoodId: {},
    );
    expect(rows.single.amount, 20);
    expect(rows.single.cost, 0);
  });

  test('null transaction price counts as zero amount', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, nov10)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, null)],
      },
      purchasePriceByGoodId: {1: 3},
    );
    expect(rows.single.amount, 0);
    expect(rows.single.cost, 6);
  });

  test('negative profit formats with minus', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, nov10)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 100)],
      },
      purchasePriceByGoodId: {1: 1300},
    );
    final table = salesByDateTableRows(rows, (_) => 'D');
    expect(table.single.value[4], '-1,200');
  });

  test('aggregates several documents on one day', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, nov10), doc(2, DateTime(2026, 11, 10, 18))],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 2, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows.single.quantity, 3);
    expect(rows.single.amount, 30);
    expect(rows.single.cost, 12);
  });

  test('dst range keeps one row per calendar day', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 3, 7),
      end: DateTime(2026, 3, 10),
      documents: [],
      transactionsByDocumentId: {},
      purchasePriceByGoodId: {},
    );
    expect(rows.map((r) => r.day.day).toList(), [10, 9, 8, 7]);
  });

  test('table row key and cells', () {
    final rows = buildSalesByDateRows(
      start: DateTime(2026, 11, 10),
      end: DateTime(2026, 11, 10),
      documents: [doc(1, nov10)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10), tx(1, 2, 1, 5)],
      },
      purchasePriceByGoodId: {1: 4, 2: null},
    );
    final table = salesByDateTableRows(rows, (_) => 'D');
    expect(table.single.key, DateTime(2026, 11, 10).millisecondsSinceEpoch);
    expect(table.single.value, ['D', '3', '25', '8', '17']);
  });
}
