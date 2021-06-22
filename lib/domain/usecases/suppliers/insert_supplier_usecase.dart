import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class InsertSupplierUseCase extends UseCase<int, InsertSupplierUseCaseParams> {
  final SupplierRepository _repository;

  InsertSupplierUseCase(this._repository);

  @override
  Future<Stream<int>> buildUseCaseStream(
      InsertSupplierUseCaseParams params) async {
    final StreamController<int> controller = StreamController();
    try {
      int supplierId = await _repository.insert(params.item);
      controller.add(supplierId);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class InsertSupplierUseCaseParams {
  final Supplier item;

  InsertSupplierUseCaseParams(this.item);
}
