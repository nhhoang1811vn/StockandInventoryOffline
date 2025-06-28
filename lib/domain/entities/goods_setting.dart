import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

part 'goods_setting.freezed.dart';

part 'goods_setting.g.dart';

@freezed
class GoodsSetting with _$GoodsSetting {
  factory GoodsSetting(
      {required SortByText sortByName,
      required SortByNumber sortByBarcode,
      required SortByNumber sortByQuantity,
      required bool hideZeroEntries,
      required bool showBarcode,
      required bool showDescription}) = _GoodsSetting;

  factory GoodsSetting.fromJson(Map<String, Object?> json) => _$GoodsSettingFromJson(json);

  factory GoodsSetting.getDefault() => GoodsSetting(
      sortByName: SortByText.no_sort,
      sortByBarcode: SortByNumber.no_sort,
      sortByQuantity: SortByNumber.no_sort,
      hideZeroEntries: false,
      showBarcode: true,
      showDescription: true);
}
