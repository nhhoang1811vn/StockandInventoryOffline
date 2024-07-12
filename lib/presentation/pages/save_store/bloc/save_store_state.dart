part of 'save_store_cubit.dart';

@freezed
class SaveStoreState with _$SaveStoreState {
  const factory SaveStoreState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String exceptionError,
    Store? item
  }) = _Initial;
}

