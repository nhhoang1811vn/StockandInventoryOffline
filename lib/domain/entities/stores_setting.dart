import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

part 'stores_setting.freezed.dart';
part 'stores_setting.g.dart';
@freezed
class StoresSetting with _$StoresSetting{
  const factory StoresSetting({
    required SortByText sortByName
  }) = _StoresSetting;

  factory StoresSetting.fromJson(Map<String, Object?> json) => _$StoresSettingFromJson(json);
  factory StoresSetting.getDefault() => StoresSetting(sortByName: SortByText.no_sort);
}


