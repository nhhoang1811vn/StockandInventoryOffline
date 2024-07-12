part of 'barcode_scanner_cubit.dart';

@freezed
class BarcodeScannerState with _$BarcodeScannerState{
  const factory BarcodeScannerState.initial({
    required BatchModeScan batchModeScan,
    required bool enableBeep,
    required bool enableVibrate
}) = _Initial;
}