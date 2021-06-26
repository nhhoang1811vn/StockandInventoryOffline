import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class GetGoodsSettingsUseCase extends UseCase<GoodsSettings, void> {
  GoodRepository repository;

  GetGoodsSettingsUseCase(this.repository);

  @override
  Future<Stream<GoodsSettings>> buildUseCaseStream(void params) async {
    final StreamController<GoodsSettings> controller = StreamController();
    try {
      GoodsSettings settings = await repository.getSettings();
      controller.add(settings);
      controller.close();
    } catch (e) {
      print(e);
      controller.addError(e);
    }
    return controller.stream;
  }
}
