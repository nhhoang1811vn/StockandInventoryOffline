part of 'home_cubit.dart';
@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial({
    required BaseState state,
    @Default(0) int quantityTotal,
    @Default(0) double purchasePriceTotal,
    @Default(0) int countDocument,
    @Default(0) int countSupplier,
    @Default(0) int countCustomer,
    @Default(0) double sumExpense,
  }) = _Initial;
}