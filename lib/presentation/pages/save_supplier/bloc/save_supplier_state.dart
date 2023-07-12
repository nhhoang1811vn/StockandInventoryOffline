part of 'save_supplier_cubit.dart';

@freezed
class SaveSupplierState with _$SaveSupplierState {
  const factory SaveSupplierState.initial({
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String address,
    @Default(Email.pure()) Email email,
    @Default('') String phone,
    @Default('') String taxID,
    @Default('') String bankDetails,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default('') String exceptionError,
    @Default(true) bool isInsert
  }) = _Initial;
}

