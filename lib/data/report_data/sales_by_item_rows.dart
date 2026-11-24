import '../../domain/entity/document.dart';
import '../../domain/entity/good.dart';
import '../../domain/entity/transaction.dart';
import 'utils.dart';

class SalesByItemRow {
  final Good good;
  final double quantity;
  final double amount;
  final double cost;

  const SalesByItemRow({
    required this.good,
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

/// One row per Good in [goods] (zeros when nothing sold), sorted by name.
/// Only documents of [type] (default outgoing) count; lines of goods not in [goods] are ignored.
/// Cost uses each good's current purchase price (null → 0).
List<SalesByItemRow> buildSalesByItemRows({
  required List<Good> goods,
  required List<Document> documents,
  required Map<int, List<DocumentTransaction>> transactionsByDocumentId,
  DocumentType type = DocumentType.outgoing,
}) {
  final accs = <int, _Acc>{
    for (final good in goods)
      if (good.id != null) good.id!: _Acc(),
  };
  final priceById = <int, double>{
    for (final good in goods)
      if (good.id != null) good.id!: good.purchasePrice ?? 0.0,
  };

  for (final document in documents) {
    if (document.type != type || document.id == null) continue;
    for (final t in transactionsByDocumentId[document.id!] ?? const []) {
      final acc = accs[t.goodId];
      if (acc == null) continue;
      acc.quantity += t.quantity;
      acc.amount += t.quantity * (t.price ?? 0.0);
      acc.cost += t.quantity * priceById[t.goodId]!;
    }
  }

  final rows = [
    for (final good in goods)
      if (good.id != null)
        SalesByItemRow(
          good: good,
          quantity: accs[good.id!]!.quantity,
          amount: accs[good.id!]!.amount,
          cost: accs[good.id!]!.cost,
        ),
  ];
  rows.sort((a, b) =>
      a.good.name.toLowerCase().compareTo(b.good.name.toLowerCase()));
  return rows;
}

List<MapEntry<int, List<String>>> salesByItemTableRows(
  List<SalesByItemRow> rows, {
  bool withCost = true,
}) {
  return rows
      .map((r) => MapEntry(r.good.id!, [
            r.good.name,
            getQuantityTextForReport(r.quantity),
            getDoubleText(r.amount),
            if (withCost) ...[
              getDoubleText(r.cost),
              getDoubleText(r.profit),
            ],
          ]))
      .toList();
}
