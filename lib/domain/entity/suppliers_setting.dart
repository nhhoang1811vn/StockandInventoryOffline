import 'package:freezed_annotation/freezed_annotation.dart';

import 'sort_by_text.dart';

part 'suppliers_setting.freezed.dart';
part 'suppliers_setting.g.dart';

@freezed
class SuppliersSetting with _$SuppliersSetting {
  const factory SuppliersSetting({required SortByText sortByName}) =
      _SuppliersSetting;

  factory SuppliersSetting.fromJson(Map<String, Object?> json) =>
      _$SuppliersSettingFromJson(json);

  factory SuppliersSetting.getDefault() =>
      SuppliersSetting(sortByName: SortByText.no_sort);
}
