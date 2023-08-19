part of 'save_good_cubit.dart';

@freezed
class SaveGoodState with _$SaveGoodState {
  const factory SaveGoodState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String barCode,
    @Default([]) List<String> files,
    //int? quantity,
    //double? price,
    Good? item,
    Document? document,
    DocumentTransaction? transaction
  }) = _Initial;
}