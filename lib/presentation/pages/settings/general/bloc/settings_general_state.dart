part of 'settings_general_cubit.dart';

@freezed
class SettingsGeneralState with _$SettingsGeneralState {
  const factory SettingsGeneralState.initial({
    @Default(false) bool enablePasscode,
    @Default("") String passcode,
  }) = _Initial;
}
