part of 'settings_data_cubit.dart';

@freezed
class SettingsDataState with _$SettingsDataState {
  const factory SettingsDataState.initial({
    @Default(false) bool enablePasscode
  }) = _Initial;
}
