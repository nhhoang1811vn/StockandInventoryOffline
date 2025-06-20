part of 'payments_cubit.dart';

@freezed
class PaymentsState with _$PaymentsState{
  const factory PaymentsState.initial({
    required BaseState state,
    @Default([]) List<Payment> allPayments,
    @Default([]) List<Payment> payments,
    @Default([]) List<PaymentCategory?> categories,
    @Default([]) List<Wallet> wallets,
    @Default([]) List<Customer> customers,
    @Default([]) List<Supplier> suppliers,
    @Default([]) List<Payment> inboundPayments,
    @Default([]) List<Payment> outboundPayments,
    PaymentsSetting? setting
  }) = _Initial;
}