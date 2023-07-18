part of 'goods_cubit2.dart';

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
    int? documentId,
    DocumentType? documentType
  }) = _Initial;
}