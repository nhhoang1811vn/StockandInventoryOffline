part of 'payments_cubit.dart';

@freezed
class PaymentsState with _$PaymentsState{
  const factory PaymentsState.initial({
    required BaseState state,
    @Default([]) List<Payment> incomingItems,
    @Default([]) List<Payment> outgoingItems
  }) = _Initial;
}