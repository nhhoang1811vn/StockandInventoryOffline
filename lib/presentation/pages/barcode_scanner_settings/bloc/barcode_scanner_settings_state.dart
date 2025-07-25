part of 'barcode_scanner_settings_cubit.dart';

@freezed
class BarcodeScannerSettingsState with _$BarcodeScannerSettingsState{
  const factory BarcodeScannerSettingsState.initial({
    required BatchModeScan batchModeScan,
    required bool enableBeep,
    required bool enableVibrate
}) = _Initial;
}