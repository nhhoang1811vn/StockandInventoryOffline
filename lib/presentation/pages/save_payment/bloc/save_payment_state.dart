part of 'save_payment_cubit.dart';

@freezed
class SavePaymentState with _$SavePaymentState {
  const factory SavePaymentState.initial({
    required BaseState state,
    @Default('') String description,
    DateTime? date,
    double? amount,
    @Default('') String exceptionError,
    Payment? item
  }) = _Initial;
}

