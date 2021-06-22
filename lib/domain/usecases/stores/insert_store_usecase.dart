import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/repositories/store_repositories.dart';

class InsertStoreUseCase extends UseCase<int, InsertStoreUseCaseParams> {
  final StoreRepository _storeRepository;

  InsertStoreUseCase(this._storeRepository);

  @override
  Future<Stream<int>> buildUseCaseStream(
      InsertStoreUseCaseParams params) async {
    final StreamController<int> controller = StreamController();
    try {
      int storeId = await _storeRepository.insert(params.store);
      controller.add(storeId);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class InsertStoreUseCaseParams {
  final Store store;

  InsertStoreUseCaseParams(this.store);
}
