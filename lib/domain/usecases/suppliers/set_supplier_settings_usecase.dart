import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class SetSupplierSettingsUseCase
    extends CompletableUseCase<SetSupplierSettingsUseCaseParams> {
  SupplierRepository repository;

  SetSupplierSettingsUseCase(this.repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      SetSupplierSettingsUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      await repository.setSettings(params.settings);
      controller.close();
    } catch (e) {
      print(e);
      controller.addError(e);
    }
    return controller.stream;
  }
}

class SetSupplierSettingsUseCaseParams {
  final SupplierSettings settings;

  SetSupplierSettingsUseCaseParams(this.settings);
}
