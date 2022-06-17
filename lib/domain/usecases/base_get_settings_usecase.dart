import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

class BaseGetSettingsUseCase<S extends BaseSettings> extends UseCase<S, void> {
  final BaseCommonRepository repository;

  BaseGetSettingsUseCase(this.repository);

  @override
  Future<Stream<S>> buildUseCaseStream(void params) async {
    final StreamController<S> controller = StreamController();
    try {
      S settings = await repository.getSettings();
      controller.add(settings);
      controller.close();
    } catch (e) {
      print(e);
      controller.addError(e);
    }
    return controller.stream;
  }
}
