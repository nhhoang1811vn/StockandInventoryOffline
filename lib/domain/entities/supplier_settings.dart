import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
part 'supplier_settings.freezed.dart';
part 'supplier_settings.g.dart';
@freezed
class SupplierSettings with _$SupplierSettings{
  const factory SupplierSettings({
    required SortByText sortByName
  }) = _SupplierSettings;

  factory SupplierSettings.fromJson(Map<String, Object?> json) => _$SupplierSettingsFromJson(json);
  factory SupplierSettings.getDefault() => SupplierSettings(sortByName: SortByText.no_sort);
}
