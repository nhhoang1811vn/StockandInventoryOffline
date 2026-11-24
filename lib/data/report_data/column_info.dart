import '../../domain/entity/entity.dart';

/// Decides from the Store's Good properties whether a report column is shown.
typedef ColumnVisibility = bool Function(GoodPropertiesSettings properties);

/// Same, driven by the Store's Document properties.
typedef DocumentColumnVisibility = bool Function(
    DocumentPropertiesSettings properties);

class ColumnInfo{
  final String name;
  bool isPickValues = false;
  bool showTotal = false;

  /// A quantity column: its cells and total follow the Store's decimals.
  final bool isQuantity;

  /// When set and it returns false, the column (and its cells) is dropped
  /// from the report. `null` means always shown.
  final ColumnVisibility? visibleWhen;

  /// Like [visibleWhen] but for Document properties (Document no, date).
  final DocumentColumnVisibility? documentVisibleWhen;

  ColumnInfo(this.name, {
    this.isPickValues = false,
    this.showTotal = false,
    this.isQuantity = false,
    this.visibleWhen,
    this.documentVisibleWhen,
  });
}

/// Ready-made visibility rules for report columns.
class ColumnGate {
  ColumnGate._();

  static bool barcode(GoodPropertiesSettings p) => p.showBarcode;

  static bool purchasePrice(GoodPropertiesSettings p) => p.showPurchasePrice;

  static bool salePrice(GoodPropertiesSettings p) => p.showSalePrice;

  /// Columns derived from both prices (e.g. profit).
  static bool bothPrices(GoodPropertiesSettings p) =>
      p.showPurchasePrice && p.showSalePrice;

  /// A figure that mixes incoming and outgoing Documents.
  static bool documentAmount(GoodPropertiesSettings p) =>
      p.showPriceForAll(DocumentType.values);

  /// The price of one Document type (incoming = Purchase, outgoing = Sale).
  static ColumnVisibility forDocumentType(DocumentType type) =>
      (p) => p.showPriceFor(type);
}

/// Visibility rules for report columns driven by Document properties.
class DocumentColumnGate {
  DocumentColumnGate._();

  static bool documentNo(DocumentPropertiesSettings p) => p.showDocumentNo;

  static bool dateTime(DocumentPropertiesSettings p) => p.showDateTime;

  static bool description(DocumentPropertiesSettings p) => p.showDescription;
}

/// Removes the columns hidden by [properties] (and, when given,
/// [documentProperties]) from the column list and from every row, keeping the
/// row keys.
({List<ColumnInfo> columns, List<MapEntry<int, List<String>>> rows})
    applyColumnVisibility(
  List<ColumnInfo> columns,
  List<MapEntry<int, List<String>>> rows,
  GoodPropertiesSettings properties, {
  DocumentPropertiesSettings? documentProperties,
}) {
  bool visible(ColumnInfo column) {
    if (!(column.visibleWhen?.call(properties) ?? true)) return false;
    if (documentProperties != null &&
        !(column.documentVisibleWhen?.call(documentProperties) ?? true)) {
      return false;
    }
    return true;
  }

  final keep = <int>[
    for (var i = 0; i < columns.length; i++)
      if (visible(columns[i])) i,
  ];
  return (
    columns: [for (final i in keep) columns[i]],
    rows: [
      for (final row in rows)
        MapEntry(row.key, [for (final i in keep) row.value[i]]),
    ],
  );
}
