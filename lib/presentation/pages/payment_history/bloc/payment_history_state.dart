part of 'payment_history_cubit.dart';

@freezed
class PaymentHistoryState with _$PaymentHistoryState {
  const factory PaymentHistoryState.initial({
    required BaseState state,
    int? documentId,
    @Default([]) List<Payment> items,
  }) = _Initial;
}
