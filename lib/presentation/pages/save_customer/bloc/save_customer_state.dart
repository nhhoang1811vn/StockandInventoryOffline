part of 'save_customer_cubit.dart';

@freezed
class SaveCustomerState with _$SaveCustomerState {
  const factory SaveCustomerState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String address,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String taxID,
    @Default('') String bankDetails,
    @Default('') String exceptionError,
    Customer? item
  }) = _Initial;
}

