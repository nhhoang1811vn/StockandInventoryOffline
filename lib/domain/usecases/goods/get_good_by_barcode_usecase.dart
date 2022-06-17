import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class GetGoodByBarcodeUseCase
    extends UseCase<Good, GetGoodByBarcodeUseCaseParams> {
  final GoodRepository _repository;

  GetGoodByBarcodeUseCase(this._repository);

  @override
  Future<Stream<Good>> buildUseCaseStream(
      GetGoodByBarcodeUseCaseParams params) async {
    final StreamController<Good> controller = StreamController();
    try {
      Good item = await _repository.getGoodByBarcode(params.barcode);
      controller.add(item);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetGoodByBarcodeUseCaseParams {
  final String barcode;

  GetGoodByBarcodeUseCaseParams(this.barcode);
}
