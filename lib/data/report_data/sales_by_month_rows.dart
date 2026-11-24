import '../../domain/entity/document.dart';
import '../../domain/entity/transaction.dart';
import 'utils.dart';

class SalesByMonthRow {
  final int month;
  final double quantity;
  final double amount;
  final double cost;

  const SalesByMonthRow({
    required this.month,
    required this.quantity,
    required this.amount,
    required this.cost,
  });

  double get profit => amount - cost;
}

class _Acc {
  double quantity = 0;
  double amount = 0;
  double cost = 0;
}

/// Always 12 rows (months 1..12) for [year]. Only outgoing documents dated in
/// [year] (local time) count. Amount uses the transaction price, Cost the
/// good's current purchase price (unknown or null → 0).
List<SalesByMonthRow> buildSalesByMonthRows({
  required int year,
  required List<Document> documents,
  required Map<int, List<DocumentTransaction>> transactionsByDocumentId,
  required Map<int, double?> purchasePriceByGoodId,
  DocumentType type = DocumentType.outgoing,
}) {
  final accs = List.generate(12, (_) => _Acc());

  for (final document in documents) {
    if (document.type != type ||
        document.id == null ||
        document.date.year != year) {
      continue;
    }
    final acc = accs[document.date.month - 1];
    for (final t in transactionsByDocumentId[document.id!] ?? const []) {
      acc.quantity += t.quantity;
      acc.amount += t.quantity * (t.price ?? 0.0);
      acc.cost += t.quantity * (purchasePriceByGoodId[t.goodId] ?? 0.0);
    }
  }

  return [
    for (var i = 0; i < 12; i++)
      SalesByMonthRow(
        month: i + 1,
        quantity: accs[i].quantity,
        amount: accs[i].amount,
        cost: accs[i].cost,
      ),
  ];
}

List<MapEntry<int, List<String>>> salesByMonthTableRows(
  List<SalesByMonthRow> rows, {
  bool withCost = true,
}) {
  return rows
      .map((r) => MapEntry(r.month, [
            '${r.month}',
            getQuantityTextForReport(r.quantity),
            getDoubleText(r.amount),
            if (withCost) ...[
              getDoubleText(r.cost),
              getDoubleText(r.profit),
            ],
          ]))
      .toList();
}
