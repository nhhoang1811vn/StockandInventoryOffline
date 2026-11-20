import '../../domain/entity/base_model.dart';
import '../../domain/entity/document.dart';
import '../../domain/entity/transaction.dart';
import 'utils.dart';

class SalesByCustomerRow {
  /// null means the "No customer" row.
  final int? customerId;
  final String? name;
  final double quantity;
  final double amount;
  final double cost;

  const SalesByCustomerRow({
    required this.customerId,
    required this.name,
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

/// All customers (sorted by name) plus a last "No customer" row, or, when
/// [onlyCustomerId] is set, just that customer (empty if not in [customers]).
/// Only documents of [type] (default outgoing) count; the person (customer or
/// supplier) is `Document.personId`. [customers] may hold Customers or Suppliers.
List<SalesByCustomerRow> buildSalesByCustomerRows({
  required List<BaseModel> customers,
  required List<Document> documents,
  required Map<int, List<DocumentTransaction>> transactionsByDocumentId,
  required Map<int, double?> purchasePriceByGoodId,
  int? onlyCustomerId,
  DocumentType type = DocumentType.outgoing,
}) {
  final listed = [
    for (final c in customers)
      if (c.id != null && (onlyCustomerId == null || c.id == onlyCustomerId)) c,
  ];
  final accs = <int, _Acc>{for (final c in listed) c.id!: _Acc()};
  final noCustomer = _Acc();

  for (final document in documents) {
    if (document.type != type || document.id == null) continue;
    _Acc? acc = accs[document.personId];
    if (acc == null) {
      if (onlyCustomerId != null) continue;
      acc = noCustomer;
    }
    for (final t in transactionsByDocumentId[document.id!] ?? const []) {
      acc.quantity += t.quantity;
      acc.amount += t.quantity * (t.price ?? 0.0);
      acc.cost += t.quantity * (purchasePriceByGoodId[t.goodId] ?? 0.0);
    }
  }

  listed.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return [
    for (final c in listed)
      SalesByCustomerRow(
        customerId: c.id,
        name: c.name,
        quantity: accs[c.id!]!.quantity,
        amount: accs[c.id!]!.amount,
        cost: accs[c.id!]!.cost,
      ),
    if (onlyCustomerId == null)
      SalesByCustomerRow(
        customerId: null,
        name: null,
        quantity: noCustomer.quantity,
        amount: noCustomer.amount,
        cost: noCustomer.cost,
      ),
  ];
}

List<MapEntry<int, List<String>>> salesByCustomerTableRows(
  List<SalesByCustomerRow> rows,
  String noCustomerLabel, {
  bool withCost = true,
}) {
  return rows
      .map((r) => MapEntry(r.customerId ?? -1, [
            r.name ?? noCustomerLabel,
            getDoubleText(r.quantity),
            getDoubleText(r.amount),
            if (withCost) ...[
              getDoubleText(r.cost),
              getDoubleText(r.profit),
            ],
          ]))
      .toList();
}
