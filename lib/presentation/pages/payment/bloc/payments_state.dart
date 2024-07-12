part of 'payments_cubit.dart';

@freezed
class PaymentsState with _$PaymentsState{
  const factory PaymentsState.initial({
    required BaseState state,
    int? documentId,
    @Default(0.0) double invoiced,
    @Default(0.0) double paid,
    @Default([]) List<Payment> items}) = _Initial;
}