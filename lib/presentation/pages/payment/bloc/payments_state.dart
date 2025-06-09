part of 'payments_cubit.dart';

@freezed
class PaymentsState with _$PaymentsState{
  const factory PaymentsState.initial({
    required BaseState state,
    @Default([]) List<Payment> payments,
    @Default([]) List<ListItem> items,
    @Default([]) List<PaymentCategory> categories,
    @Default([]) List<Wallet> wallets,
    @Default([]) List<Payment> inboundPayments,
    @Default([]) List<ListItem> inboundItems,
    @Default([]) List<Payment> outboundPayments,
    @Default([]) List<ListItem> outboundItems,
    PaymentsSetting? setting
  }) = _Initial;
}