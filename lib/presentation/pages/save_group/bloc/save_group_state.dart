part of 'save_group_cubit.dart';
@freezed
class SaveGroupState with _$SaveGroupState {
  const factory SaveGroupState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String barCode,
    @Default([]) List<String> files,
    @Default('') String exceptionError,
    Group? item
  }) = _Initial;
}