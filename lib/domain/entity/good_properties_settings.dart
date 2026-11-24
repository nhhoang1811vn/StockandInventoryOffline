import 'package:freezed_annotation/freezed_annotation.dart';

import 'document.dart';
import 'good.dart';

part 'good_properties_settings.freezed.dart';
part 'good_properties_settings.g.dart';

/// Per-Store visibility of optional Good properties. All visible by default.
@freezed
class GoodPropertiesSettings with _$GoodPropertiesSettings {
  factory GoodPropertiesSettings({
    @Default(true) bool showImage,
    @Default(true) bool showBarcode,
    @Default(true) bool showDescription,
    @Default(true) bool showMinQuantity,
    @Default(true) bool showPurchasePrice,
    @Default(true) bool showSalePrice,
    // Validation rules (off by default): no two Goods of a Store with the same
    // barcode / no two Groups of a Store with the same name.
    @Default(false) bool uniqueBarcode,
    @Default(false) bool uniqueGroupName,
  }) = _GoodPropertiesSettings;

  factory GoodPropertiesSettings.fromJson(Map<String, Object?> json) =>
      _$GoodPropertiesSettingsFromJson(json);
}

extension GoodPropertiesDocumentPrice on GoodPropertiesSettings {
  /// Incoming documents use the Purchase price, outgoing the Sale price.
  bool showPriceFor(DocumentType type) =>
      type == DocumentType.incoming ? showPurchasePrice : showSalePrice;

  /// Whether a figure that mixes several Documents (a summary) can be shown:
  /// every Document type present must show its price.
  bool showPriceForAll(Iterable<DocumentType> types) =>
      types.every(showPriceFor);

  /// The Good's default price for a Document line, or `null` when that price
  /// is hidden (a hidden price is never silently applied to a Document).
  double? defaultPriceFor(Good good, DocumentType type) {
    if (!showPriceFor(type)) return null;
    return type == DocumentType.incoming ? good.purchasePrice : good.salePrice;
  }
}
