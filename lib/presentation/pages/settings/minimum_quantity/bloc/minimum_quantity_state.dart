part of 'minimum_quantity_cubit.dart';

@freezed
class MinimumQuantityState with _$MinimumQuantityState {
  const factory MinimumQuantityState.initial({
    MinimumQuantitySettings? settings,
    @Default(true) bool showInItem,
    @Default(true) bool showInList,
    Color? color,
    @Default(true) bool showAlert,
  }) = _Initial;
}
