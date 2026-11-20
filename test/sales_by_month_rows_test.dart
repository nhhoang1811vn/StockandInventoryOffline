import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/report_data/sales_by_month_rows.dart';
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
  test('always 12 rows with zeros', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [],
      transactionsByDocumentId: {},
      purchasePriceByGoodId: {},
    );
    expect(rows.length, 12);
    expect(rows.map((r) => r.month).toList(), List.generate(12, (i) => i + 1));
    for (final r in rows) {
      expect(r.quantity, 0);
      expect(r.amount, 0);
      expect(r.cost, 0);
      expect(r.profit, 0);
    }
  });

  test('sums a month', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [doc(1, DateTime(2026, 3, 10, 9))],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10), tx(1, 2, 1, 5)],
      },
      purchasePriceByGoodId: {1: 4, 2: null},
    );
    final march = rows[2];
    expect(march.quantity, 3);
    expect(march.amount, 25);
    expect(march.cost, 8);
    expect(march.profit, 17);
    expect(rows.where((r) => r.month != 3).every((r) => r.amount == 0), isTrue);
  });

  test('aggregates several documents in one month', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [doc(1, DateTime(2026, 5, 2)), doc(2, DateTime(2026, 5, 28))],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 2, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows[4].quantity, 3);
    expect(rows[4].amount, 30);
    expect(rows[4].cost, 12);
  });

  test('year boundaries', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [
        doc(1, DateTime(2026, 1, 1)),
        doc(2, DateTime(2026, 12, 31, 23, 59, 59)),
        doc(3, DateTime(2027, 1, 1)),
        doc(4, DateTime(2025, 12, 31, 23, 59, 59)),
      ],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 2, 10)],
        3: [tx(3, 1, 100, 10)],
        4: [tx(4, 1, 100, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows[0].quantity, 1);
    expect(rows[11].quantity, 2);
    expect(rows.fold<double>(0, (s, r) => s + r.quantity), 3);
  });

  test('ignores incoming documents', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [doc(1, DateTime(2026, 3, 10), DocumentType.incoming)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 5, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows[2].quantity, 0);
    expect(rows[2].amount, 0);
  });

  test('null price counts as zero amount; unknown good gives zero cost', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [doc(1, DateTime(2026, 3, 10))],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, null), tx(1, 99, 1, 10)],
      },
      purchasePriceByGoodId: {1: 3},
    );
    expect(rows[2].amount, 10);
    expect(rows[2].cost, 6);
  });

  test('negative profit formats with minus', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [doc(1, DateTime(2026, 3, 10))],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 100)],
      },
      purchasePriceByGoodId: {1: 1300},
    );
    expect(salesByMonthTableRows(rows)[2].value[4], '-1,200');
  });

  test('table row key and cells', () {
    final rows = buildSalesByMonthRows(
      year: 2026,
      documents: [doc(1, DateTime(2026, 3, 10, 9))],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10), tx(1, 2, 1, 5)],
      },
      purchasePriceByGoodId: {1: 4, 2: null},
    );
    final table = salesByMonthTableRows(rows);
    expect(table.length, 12);
    expect(table[2].key, 3);
    expect(table[2].value, ['3', '3', '25', '8', '17']);
  });
}
