part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial({
    @Default(false) bool enablePasscode,
    @Default("") String passcode,
  }) = _Initial;
}
