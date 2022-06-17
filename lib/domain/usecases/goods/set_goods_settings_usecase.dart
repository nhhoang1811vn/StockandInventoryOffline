import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class SetGoodsSettingsUseCase
    extends CompletableUseCase<SetGoodsSettingsUseCaseParams> {
  GoodRepository repository;

  SetGoodsSettingsUseCase(this.repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      SetGoodsSettingsUseCaseParams params) async {
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

class SetGoodsSettingsUseCaseParams {
  final GoodsSettings settings;

  SetGoodsSettingsUseCaseParams(this.settings);
}
