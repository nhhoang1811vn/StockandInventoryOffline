part of 'settings_general_cubit.dart';

@freezed
class SettingsGeneralState with _$SettingsGeneralState {
  const factory SettingsGeneralState.initial({
    @Default(false) bool enablePasscode,
    @Default("") String passcode,
    @Default(false) bool enableFingerprint,
    @Default(false) bool canUseBiometrics,
    @Default(AppSettings.defaultAutoLockMinutes) int autoLockMinutes,
    @Default(Currency.usd) Currency currency,
    @Default(AppSettings.defaultImageSize) int imageSize,
    @Default(true) bool showCropWindow,
  }) = _Initial;
}
