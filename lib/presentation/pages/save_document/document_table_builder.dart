import '../../../domain/entity/entity.dart';

/// Builds the goods table shared by the Document CSV and PDF exports.
/// Columns of Good properties the Store turned off are left out; price and
/// amount follow the Purchase price (incoming) / Sale price (outgoing).
List<List<String>> buildDocumentTable({
  required List<DocumentTransaction> transactions,
  required DocumentType type,
  required GoodPropertiesSettings properties,
  required String Function(String key) tr,
}) {
  final showDescription = properties.showDescription;
  final showBarcode = properties.showBarcode;
  final showPrice = properties.showPriceFor(type);

  final data = <List<String>>[
    [
      tr("name"),
      if (showDescription) tr("label_description"),
      if (showBarcode) tr("barcode"),
      if (showPrice) tr("price"),
      tr("quantity"),
      if (showPrice) tr("amount"),
    ],
  ];
  var totalQuantity = 0.0;
  var totalAmount = 0.0;
  for (final item in transactions) {
    totalQuantity += item.quantity;
    final amount = item.quantity * (item.price ?? 0.0);
    totalAmount += amount;
    data.add([
      item.good.name,
      if (showDescription) item.good.description,
      if (showBarcode) item.good.barCode ?? "",
      if (showPrice) item.price.toString(),
      item.quantity.toString(),
      if (showPrice) amount.toString(),
    ]);
  }
  data.add([
    tr("total"),
    if (showDescription) "",
    if (showBarcode) "",
    if (showPrice) "",
    totalQuantity.toString(),
    if (showPrice) totalAmount.toString(),
  ]);
  return data;
}
