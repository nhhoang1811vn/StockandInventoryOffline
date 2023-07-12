part of 'suppliers_cubit.dart';

@freezed
class SuppliersState with _$SuppliersState {
  const factory SuppliersState.initial({
    BaseState? state,
    @Default([]) List<Supplier> allItems,
    @Default([]) List<Supplier> items,
    @Default('') String textSearch,
    required SupplierSettings settings,
    @Default(false) bool showSearchBar,
    @Default(false) bool isSelection
  }) = _Initial;
}