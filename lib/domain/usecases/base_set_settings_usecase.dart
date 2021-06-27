import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

class BaseSetSettingsUseCase<S extends BaseSettings>
    extends CompletableUseCase<BaseSetSettingsUseCaseParam<S>> {
  final BaseCommonRepository repository;

  BaseSetSettingsUseCase(this.repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      BaseSetSettingsUseCaseParam params) async {
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

class BaseSetSettingsUseCaseParam<S extends BaseSettings> {
  final S settings;

  BaseSetSettingsUseCaseParam(this.settings);
}
