part of 'save_group_cubit.dart';
@freezed
class SaveGroupState with _$SaveGroupState {
  const factory SaveGroupState.initial({
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String barCode,
    @Default([]) List<String> files,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default('') String exceptionError,
    Group? item
  }) = _Initial;
}