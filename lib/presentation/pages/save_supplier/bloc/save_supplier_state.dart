part of 'save_supplier_cubit.dart';

@freezed
class SaveSupplierState with _$SaveSupplierState {
  const factory SaveSupplierState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String address,
    @Default(Email.pure()) Email email,
    @Default('') String phone,
    @Default('') String taxID,
    @Default('') String bankDetails,
    @Default('') String exceptionError,
    Supplier? item
  }) = _Initial;
}

