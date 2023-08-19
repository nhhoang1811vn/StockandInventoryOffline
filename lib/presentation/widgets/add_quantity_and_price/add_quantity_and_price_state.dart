part of 'add_quantity_and_price_cubit.dart';

@freezed
class AddQuantityAndPriceState with _$AddQuantityAndPriceState {
  const factory AddQuantityAndPriceState.initial({
    required BaseState state,
    @Default(1) int quantity,
    @Default(0.0) double price,
    @Default(0.0) double amount
  }) = _Initial;
}