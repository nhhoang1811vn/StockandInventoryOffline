part of 'save_store_cubit.dart';

@freezed
class SaveStoreState with _$SaveStoreState {
  const factory SaveStoreState.initial({
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default('') String exceptionError,
    Store? item
  }) = _Initial;
}

