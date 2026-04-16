part of 'stores_cubit.dart';

@freezed
class StoresState with _$StoresState {
  const factory StoresState.initial({
    required BaseState state,
    @Default([]) List<Store> allItems,
    @Default([]) List<Store> items,
    @Default('') String textSearch,
    required StoresSetting settings,
    @Default(false) bool showSearchBar,
    @Default(false) bool isSelection,
  }) = _Initial;
}
