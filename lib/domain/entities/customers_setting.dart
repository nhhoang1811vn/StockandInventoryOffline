import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

part 'customers_setting.freezed.dart';
part 'customers_setting.g.dart';
@freezed
class CustomersSetting with _$CustomersSetting{
  const factory CustomersSetting({
    required SortByText sortByName
  }) = _CustomersSetting;

  factory CustomersSetting.fromJson(Map<String, Object?> json) => _$CustomersSettingFromJson(json);
  factory CustomersSetting.getDefault() => CustomersSetting(sortByName: SortByText.no_sort);
}
