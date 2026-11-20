import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/report_data/sales_by_customer_rows.dart';
import 'package:good_manager/data/report_data/sales_by_date_rows.dart';
import 'package:good_manager/data/report_data/sales_by_item_rows.dart';
import 'package:good_manager/data/report_data/sales_by_month_rows.dart';
import 'package:good_manager/domain/entity/entity.dart';

Document doc(int id, DateTime date, DocumentType type, {int? personId}) {
  return Document()
    ..id = id
    ..date = date
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
  final day = DateTime(2026, 3, 10, 9);
  final documents = [
    doc(1, day, DocumentType.incoming, personId: 1),
    doc(2, day, DocumentType.outgoing, personId: 1),
  ];
  final transactions = {
    1: [tx(1, 1, 2, 10)],
    2: [tx(2, 1, 100, 99)],
  };

  test('by date: incoming type counts only incoming documents', () {
    final rows = buildSalesByDateRows(
      type: DocumentType.incoming,
      start: DateTime(2026, 3, 10),
      end: DateTime(2026, 3, 10),
      documents: documents,
      transactionsByDocumentId: transactions,
      purchasePriceByGoodId: {},
    );
    expect(rows.single.quantity, 2);
    expect(rows.single.amount, 20);
  });

  test('by date: table without cost has date, quantity and amount only', () {
    final rows = buildSalesByDateRows(
      type: DocumentType.incoming,
      start: DateTime(2026, 3, 10),
      end: DateTime(2026, 3, 10),
      documents: documents,
      transactionsByDocumentId: transactions,
      purchasePriceByGoodId: {},
    );
    expect(salesByDateTableRows(rows, (_) => 'D', withCost: false).single.value,
        ['D', '2', '20']);
  });

  test('by item: incoming type counts only incoming documents', () {
    final good = Good()
      ..id = 1
      ..name = 'A';
    final rows = buildSalesByItemRows(
      type: DocumentType.incoming,
      goods: [good],
      documents: documents,
      transactionsByDocumentId: transactions,
    );
    expect(rows.single.quantity, 2);
    expect(rows.single.amount, 20);
    expect(salesByItemTableRows(rows, withCost: false).single.value,
        ['A', '2', '20']);
  });

  test('by month: incoming type counts only incoming documents', () {
    final rows = buildSalesByMonthRows(
      type: DocumentType.incoming,
      year: 2026,
      documents: documents,
      transactionsByDocumentId: transactions,
      purchasePriceByGoodId: {},
    );
    expect(rows.length, 12);
    expect(rows[2].quantity, 2);
    expect(rows[2].amount, 20);
    expect(salesByMonthTableRows(rows, withCost: false)[2].value,
        ['3', '2', '20']);
  });

  test('by supplier: suppliers are listed with a no-supplier row last', () {
    final supplier = Supplier()
      ..id = 1
      ..name = 'S';
    final rows = buildSalesByCustomerRows(
      type: DocumentType.incoming,
      customers: [supplier],
      documents: [
        ...documents,
        doc(3, day, DocumentType.incoming),
      ],
      transactionsByDocumentId: {
        ...transactions,
        3: [tx(3, 1, 1, 5)],
      },
      purchasePriceByGoodId: {},
    );
    expect(rows.length, 2);
    expect(rows[0].name, 'S');
    expect(rows[0].quantity, 2);
    expect(rows[0].amount, 20);
    expect(rows[1].customerId, isNull);
    expect(rows[1].amount, 5);
    final table = salesByCustomerTableRows(rows, 'NS', withCost: false);
    expect(table[0].value, ['S', '2', '20']);
    expect(table[1].value, ['NS', '1', '5']);
  });

  test('by supplier: single supplier excludes others and no-supplier', () {
    final s1 = Supplier()
      ..id = 1
      ..name = 'S1';
    final s2 = Supplier()
      ..id = 2
      ..name = 'S2';
    final rows = buildSalesByCustomerRows(
      type: DocumentType.incoming,
      customers: [s1, s2],
      documents: [
        doc(1, day, DocumentType.incoming, personId: 1),
        doc(2, day, DocumentType.incoming, personId: 2),
        doc(3, day, DocumentType.incoming),
      ],
      transactionsByDocumentId: {
        1: [tx(1, 1, 1, 10)],
        2: [tx(2, 1, 5, 10)],
        3: [tx(3, 1, 7, 10)],
      },
      purchasePriceByGoodId: {},
      onlyCustomerId: 2,
    );
    expect(rows.length, 1);
    expect(rows.single.name, 'S2');
    expect(rows.single.quantity, 5);
  });
}
