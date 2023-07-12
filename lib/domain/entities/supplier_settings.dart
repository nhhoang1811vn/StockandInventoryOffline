import 'sort_by_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'supplier_settings.freezed.dart';
@freezed
class SupplierSettings with _$SupplierSettings{
  const factory SupplierSettings({
    required String sortByName
  }) = _SupplierSettings;

  factory SupplierSettings.fromJson(Map<String, Object?> json) => _$SupplierSettingsFromJson(json);
}
