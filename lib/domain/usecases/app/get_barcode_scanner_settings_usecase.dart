import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';
import 'package:good_manager/domain/repositories/app_repository.dart';

class GetBarcodeScannerSettingsUseCase
    extends UseCase<BarcodeScannerSettings, void> {
  final AppRepository repository;

  GetBarcodeScannerSettingsUseCase(this.repository);

  @override
  Future<Stream<BarcodeScannerSettings>> buildUseCaseStream(void params) async {
    final StreamController<BarcodeScannerSettings> controller =
        StreamController();
    try {
      BarcodeScannerSettings settings =
          await repository.getBarcodeScannerSettings();
      controller.add(settings);
      controller.close();
    } catch (e) {
      print(e);
      controller.addError(e);
    }
    return controller.stream;
  }
}
