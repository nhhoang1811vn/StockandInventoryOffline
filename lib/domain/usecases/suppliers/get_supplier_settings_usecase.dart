import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class GetSupplierSettingsUseCase extends UseCase<SupplierSettings, void> {
  SupplierRepository repository;

  GetSupplierSettingsUseCase(this.repository);

  @override
  Future<Stream<SupplierSettings>> buildUseCaseStream(void params) async {
    final StreamController<SupplierSettings> controller = StreamController();
    try {
      SupplierSettings settings = await repository.getSettings();
      controller.add(settings);
      controller.close();
    } catch (e) {
      print(e);
      controller.addError(e);
    }
    return controller.stream;
  }
}
