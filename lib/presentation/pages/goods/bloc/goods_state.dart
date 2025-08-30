part of 'goods_cubit.dart';

@freezed
class GoodsState with _$GoodsState {
  const factory GoodsState.initial({
    required BaseState state,
    @Default([]) List<Good> allGoods,
    @Default([]) List<Group> allGroups,
    @Default([]) List<Good> goods,
    @Default([]) List<Group> groups,
    @Default('') String textSearch,
    @Default([]) List<Group> selectedGroups,
    required GoodsSetting settings,
    @Default(false) bool showSearchBar,
    @Default(false) bool isSelection,
    Document? document,
    @Default(0) double quantityTotal,
    @Default(0) double purchasePriceTotal,
    @Default(0) double salePriceTotal,
    @Default(true) bool showMinQuantity,
    Color? minQuantityColor,
  }) = _Initial;
}
