import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';

abstract class AppRepository {
  Future<void> setBarcodeScannerSettings(BarcodeScannerSettings settings);

  Future<BarcodeScannerSettings> getBarcodeScannerSettings();
}
