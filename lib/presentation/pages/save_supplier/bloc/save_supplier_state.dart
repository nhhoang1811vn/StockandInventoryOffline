part of 'save_supplier_cubit.dart';

@freezed
class SaveSupplierState with _$SaveSupplierState {
  const factory SaveSupplierState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String address,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String taxID,
    @Default('') String bankDetails,
    String? file,
    @Default('') String exceptionError,
    Supplier? item,
  }) = _Initial;
}
