part of 'save_payment_cubit.dart';

@freezed
class SavePaymentState with _$SavePaymentState {
  const factory SavePaymentState.initial({
    required BaseState state,
    @Default('') String description,
    int? documentId,
    //@Default(NameInput.pure()) NameInput documentName,
    DateTime? date,
    double? amount,
    @Default('') String exceptionError,
    Payment? item,
    @Default([]) List<PaymentCategory> categories,
    PaymentCategory? selectedCategory,

    @Default([]) List<Wallet> wallets,
    Wallet? selectedWallet,

    int? supplierId,
    int? customerId,

    Document? document,
    Supplier? supplier,
    Customer? customer

  }) = _Initial;
}

