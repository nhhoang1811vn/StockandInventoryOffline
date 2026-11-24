import 'package:freezed_annotation/freezed_annotation.dart';

import 'document.dart';

part 'document_properties_settings.freezed.dart';
part 'document_properties_settings.g.dart';

/// Per-Store visibility of optional Document properties. All visible by
/// default. Hidden values are still stored (a Document keeps its number and
/// date), they are just not displayed.
@freezed
class DocumentPropertiesSettings with _$DocumentPropertiesSettings {
  factory DocumentPropertiesSettings({
    @Default(true) bool showImage,
    @Default(true) bool showDocumentNo,
    @Default(true) bool showDateTime,
    @Default(true) bool showDescription,
  }) = _DocumentPropertiesSettings;

  factory DocumentPropertiesSettings.fromJson(Map<String, Object?> json) =>
      _$DocumentPropertiesSettingsFromJson(json);
}

extension DocumentPropertiesDisplay on DocumentPropertiesSettings {
  /// The title to show for a Document: its number, or its type label
  /// ("incoming" / "outgoing" translation key) when the number is hidden.
  String displayName(Document document, String Function(String key) tr) =>
      showDocumentNo
          ? document.name
          : tr(
              document.type == DocumentType.incoming ? "incoming" : "outgoing");
}
