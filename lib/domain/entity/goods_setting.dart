import 'package:freezed_annotation/freezed_annotation.dart';

import 'sort_by_number.dart';
import 'sort_by_text.dart';

part 'goods_setting.freezed.dart';
part 'goods_setting.g.dart';

enum PriceDisplayMode { price, amount }

@freezed
class GoodsSetting with _$GoodsSetting {
  factory GoodsSetting({
    required SortByText sortByName,
    required SortByNumber sortByBarcode,
    required SortByNumber sortByQuantity,
    required bool hideZeroEntries,
    required bool showBarcode,
    required bool showDescription,
    @Default(true) bool showPurchasePrice,
    @Default(PriceDisplayMode.price) PriceDisplayMode purchaseDisplayMode,
    @Default(true) bool showSalePrice,
    @Default(PriceDisplayMode.price) PriceDisplayMode saleDisplayMode,
    @Default(true) bool showMinQuantity,
    @Default(1) int gridColumnCount,
  }) = _GoodsSetting;

  factory GoodsSetting.fromJson(Map<String, Object?> json) =>
      _$GoodsSettingFromJson(json);

  factory GoodsSetting.getDefault() => GoodsSetting(
        sortByName: SortByText.no_sort,
        sortByBarcode: SortByNumber.no_sort,
        sortByQuantity: SortByNumber.no_sort,
        hideZeroEntries: false,
        showBarcode: true,
        showDescription: true,
        showPurchasePrice: true,
        purchaseDisplayMode: PriceDisplayMode.price,
        showSalePrice: true,
        saleDisplayMode: PriceDisplayMode.price,
        showMinQuantity: true,
        gridColumnCount: 1,
      );
}
