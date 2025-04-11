part of 'save_payment_category_cubit.dart';

@freezed
class SavePaymentCategoryState with _$SavePaymentCategoryState {
  const factory SavePaymentCategoryState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    Color? color,
    PaymentCategory? item
  }) = _Initial;
}

