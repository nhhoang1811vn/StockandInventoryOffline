import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/report_data/sales_by_customer_rows.dart';
import 'package:good_manager/domain/entity/entity.dart';

Customer customer(int id, String name) {
  return Customer()
    ..id = id
    ..name = name;
}

Document doc(int id, int? personId,
    [DocumentType type = DocumentType.outgoing]) {
  return Document()
    ..id = id
    ..type = type
    ..personId = personId;
}

DocumentTransaction tx(int documentId, int goodId, double quantity, double? price) {
  return DocumentTransaction()
    ..documentId = documentId
    ..goodId = goodId
    ..quantity = quantity
    ..price = price;
}

void main() {
  test('all: one row per customer, zeros for non-buyers, no-customer row last',
      () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A'), customer(2, 'B')],
      documents: [doc(1, 1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows.length, 3);
    expect(rows[0].name, 'A');
    expect(rows[0].quantity, 2);
    expect(rows[0].amount, 20);
    expect(rows[0].cost, 8);
    expect(rows[0].profit, 12);
    expect(rows[1].name, 'B');
    expect(rows[1].quantity, 0);
    expect(rows[1].amount, 0);
    expect(rows[2].customerId, isNull);
    expect(rows[2].amount, 0);
  });

  test('no-customer row collects null and unknown customers', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A')],
      documents: [doc(1, null), doc(2, 99)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 2, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows.last.customerId, isNull);
    expect(rows.last.quantity, 3);
    expect(rows.last.amount, 30);
    expect(rows.last.cost, 12);
    expect(rows.first.quantity, 0);
  });

  test('single customer: only that row, others and no-customer ignored', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A'), customer(2, 'B')],
      documents: [doc(1, 1), doc(2, 2), doc(3, null)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 5, 10)],
        3: [tx(3, 1, 7, 10)],
      },
      purchasePriceByGoodId: {1: 4},
      onlyCustomerId: 1,
    );
    expect(rows.length, 1);
    expect(rows.single.name, 'A');
    expect(rows.single.quantity, 1);
    expect(rows.single.amount, 10);
  });

  test('single customer missing from list gives empty', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A')],
      documents: [doc(1, 1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
      },
      purchasePriceByGoodId: {1: 4},
      onlyCustomerId: 77,
    );
    expect(rows, isEmpty);
  });

  test('ignores incoming documents', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A')],
      documents: [doc(1, 1, DocumentType.incoming)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 5, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    expect(rows.first.quantity, 0);
    expect(rows.last.quantity, 0);
  });

  test('null price counts as zero amount; unknown good gives zero cost', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A')],
      documents: [doc(1, 1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, null), tx(1, 99, 1, 10)],
      },
      purchasePriceByGoodId: {1: 3},
    );
    expect(rows.first.amount, 10);
    expect(rows.first.cost, 6);
  });

  test('sorted by name case-insensitive', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'b'), customer(2, 'A'), customer(3, 'C')],
      documents: [],
      transactionsByDocumentId: {},
      purchasePriceByGoodId: {},
    );
    expect(rows.map((r) => r.name).toList(), ['A', 'b', 'C', null]);
  });

  test('same name customers stay separate', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'X'), customer(2, 'X')],
      documents: [],
      transactionsByDocumentId: {},
      purchasePriceByGoodId: {},
    );
    final table = salesByCustomerTableRows(rows, 'NC');
    expect(table.map((e) => e.key).toSet(), {1, 2, -1});
  });

  test('table cells and labels', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A')],
      documents: [doc(1, 1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 2, 10)],
      },
      purchasePriceByGoodId: {1: 4},
    );
    final table = salesByCustomerTableRows(rows, 'NC');
    expect(table.first.key, 1);
    expect(table.first.value, ['A', '2', '20', '8', '12']);
    expect(table.last.key, -1);
    expect(table.last.value.first, 'NC');
  });

  test('negative profit formats with minus', () {
    final rows = buildSalesByCustomerRows(
      customers: [customer(1, 'A')],
      documents: [doc(1, 1)],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 100)],
      },
      purchasePriceByGoodId: {1: 1300},
    );
    expect(salesByCustomerTableRows(rows, 'NC').first.value[4], '-1,200');
  });
}
