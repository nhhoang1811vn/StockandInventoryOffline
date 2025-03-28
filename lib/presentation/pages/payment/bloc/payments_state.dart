part of 'payments_cubit.dart';

@freezed
class PaymentsState with _$PaymentsState{
  const factory PaymentsState.initial({
    required BaseState state,
    @Default([]) List<Payment> inboundItems,
    @Default([]) List<Payment> outboundItems
  }) = _Initial;
}