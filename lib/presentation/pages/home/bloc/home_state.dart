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
    int? selectedWalletId,
    @Default(0) double totalBalance,
    Color? incomingColor,
    Color? outgoingColor,
    @Default([]) List<Payment> payments,
    @Default([]) List<Payment> allPayments,
    @Default([]) List<Document> recentDocuments,
    @Default(true) bool isLoadingRecentDocuments,
    @Default(true) bool isLoadingWallets,
    @Default(0) int countDocuments,
    @Default(0) int outOfStockCount,
    @Default(0) int lowStockCount,
    @Default([]) List<Good> allGoods,
    @Default([]) List<Good> outOfStockGoods,
    @Default([]) List<Good> lowStockGoods,
    Store? selectedStore,
  }) = _Initial;
}
