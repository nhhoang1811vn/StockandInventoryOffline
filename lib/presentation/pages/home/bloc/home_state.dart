part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial({
    required BaseState state,
    @Default(0) int countGoods,
    @Default(0) double quantityTotal,
    @Default(0) int countIncomingDocument,
    @Default(0) double sumPriceIncomingDocument,
    @Default(0) int countOutgoingDocument,
    @Default(0) double sumPriceOutgoingDocument,
    @Default(0) int countSupplier,
    @Default(0) int countCustomer,
    @Default(0) double sumExpense,
    @Default([]) List<Wallet> wallets,
    @Default(0) double totalBalance,
    Color? incomingColor,
    Color? outgoingColor,
    @Default([]) List<Payment> payments,
  }) = _Initial;
}
