part of 'suppliers_cubit.dart';

@freezed
class SuppliersState with _$SuppliersState {
  const factory SuppliersState.initial({
    required BaseState state,
    @Default([]) List<Supplier> allItems,
    @Default([]) List<Supplier> items,
    @Default('') String textSearch,
    required SuppliersSetting settings,
    @Default(false) bool showSearchBar,
    @Default(false) bool isSelection,
  }) = _Initial;
}
