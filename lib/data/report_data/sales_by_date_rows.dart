import '../../domain/entity/document.dart';
import '../../domain/entity/transaction.dart';
import 'utils.dart';

class SalesByDateRow {
  final DateTime day;
  final double quantity;
  final double amount;
  final double cost;

  const SalesByDateRow({
    required this.day,
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

/// One row per calendar day from [start] to [end] inclusive, newest first.
/// Only documents of [type] (default outgoing) count. Amount uses the transaction price, Cost the
/// good's current purchase price (unknown or null → 0).
List<SalesByDateRow> buildSalesByDateRows({
  required DateTime start,
  required DateTime end,
  required List<Document> documents,
  required Map<int, List<DocumentTransaction>> transactionsByDocumentId,
  required Map<int, double?> purchasePriceByGoodId,
  DocumentType type = DocumentType.outgoing,
}) {
  final days = <DateTime>[];
  var d = DateTime(start.year, start.month, start.day);
  final last = DateTime(end.year, end.month, end.day);
  while (!d.isAfter(last)) {
    days.add(d);
    d = DateTime(d.year, d.month, d.day + 1);
  }

  final accs = {for (final day in days) day: _Acc()};

  for (final document in documents) {
    if (document.type != type || document.id == null) continue;
    final acc = accs[DateTime(
      document.date.year,
      document.date.month,
      document.date.day,
    )];
    if (acc == null) continue;
    for (final t in transactionsByDocumentId[document.id!] ?? const []) {
      acc.quantity += t.quantity;
      acc.amount += t.quantity * (t.price ?? 0.0);
      acc.cost += t.quantity * (purchasePriceByGoodId[t.goodId] ?? 0.0);
    }
  }

  return days.reversed
      .map((day) => SalesByDateRow(
            day: day,
            quantity: accs[day]!.quantity,
            amount: accs[day]!.amount,
            cost: accs[day]!.cost,
          ))
      .toList();
}

List<MapEntry<int, List<String>>> salesByDateTableRows(
  List<SalesByDateRow> rows,
  String Function(DateTime) formatDate, {
  bool withCost = true,
}) {
  return rows
      .map((r) => MapEntry(r.day.millisecondsSinceEpoch, [
            formatDate(r.day),
            getDoubleText(r.quantity),
            getDoubleText(r.amount),
            if (withCost) ...[
              getDoubleText(r.cost),
              getDoubleText(r.profit),
            ],
          ]))
      .toList();
}
