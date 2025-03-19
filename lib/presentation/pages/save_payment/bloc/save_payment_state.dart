part of 'save_payment_cubit.dart';

@freezed
class SavePaymentState with _$SavePaymentState {
  const factory SavePaymentState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    int? documentId,
    @Default(NameInput.pure()) NameInput documentName,
    //@Default('') String documentName,
    DateTime? date,
    double? amount,
    @Default('') String exceptionError,
    Payment? item
  }) = _Initial;
}

