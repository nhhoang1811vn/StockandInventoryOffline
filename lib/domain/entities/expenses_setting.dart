import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'expenses_setting.freezed.dart';
part 'expenses_setting.g.dart';
@freezed
class ExpensesSetting with _$ExpensesSetting{
  factory ExpensesSetting({required SortByText sortByName}) = _ExpensesSetting;

  factory ExpensesSetting.fromJson(Map<String, Object?> json) => _$ExpensesSettingFromJson(json);
  factory ExpensesSetting.getDefault() => ExpensesSetting(sortByName: SortByText.no_sort);
}
