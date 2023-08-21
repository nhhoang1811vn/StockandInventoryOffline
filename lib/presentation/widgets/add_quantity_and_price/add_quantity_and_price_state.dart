part of 'add_quantity_and_price_cubit.dart';

@freezed
class AddQuantityAndPriceState with _$AddQuantityAndPriceState {
  const factory AddQuantityAndPriceState.initial({
    required BaseState state,
    @Default(1) int quantity,
    double? price,
    double? amount
  }) = _Initial;
}