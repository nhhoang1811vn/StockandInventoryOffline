part of 'payment_categories_cubit.dart';

@freezed
class PaymentCategoriesState with _$PaymentCategoriesState{
  const factory PaymentCategoriesState.initial({
    required BaseState state,
    @Default([]) List<PaymentCategory> inboundCategories,
    @Default([]) List<PaymentCategory> outboundCategories,
  }) = _Initial;
}