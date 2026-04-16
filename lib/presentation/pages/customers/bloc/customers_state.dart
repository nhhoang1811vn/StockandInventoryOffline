part of 'customers_cubit.dart';

@freezed
class CustomersState with _$CustomersState {
  const factory CustomersState.initial({
    required BaseState state,
    @Default([]) List<Customer> allItems,
    @Default([]) List<Customer> items,
    @Default('') String textSearch,
    required CustomersSetting settings,
    @Default(false) bool showSearchBar,
    @Default(false) bool isSelection,
  }) = _Initial;
}
