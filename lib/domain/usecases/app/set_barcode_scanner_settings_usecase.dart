import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';
import 'package:good_manager/domain/repositories/app_repository.dart';

class SetBarcodeScannerSettingsUseCase
    extends CompletableUseCase<SetBarcodeScannerSettingsParams> {
  final AppRepository repository;

  SetBarcodeScannerSettingsUseCase(this.repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      SetBarcodeScannerSettingsParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      await repository.setBarcodeScannerSettings(params.settings);
      controller.close();
    } catch (e) {
      print(e);
      controller.addError(e);
    }
    return controller.stream;
  }
}

class SetBarcodeScannerSettingsParams {
  final BarcodeScannerSettings settings;

  SetBarcodeScannerSettingsParams(this.settings);
}
