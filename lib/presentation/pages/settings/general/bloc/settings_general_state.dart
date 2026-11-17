part of 'settings_general_cubit.dart';

@freezed
class SettingsGeneralState with _$SettingsGeneralState {
  const factory SettingsGeneralState.initial({
    @Default(false) bool enablePasscode,
    @Default("") String passcode,
    @Default(Currency.usd) Currency currency,
    @Default(AppSettings.defaultImageSize) int imageSize,
    @Default(true) bool showCropWindow,
  }) = _Initial;
}
