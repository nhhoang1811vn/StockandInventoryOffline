import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class InsertSupplierUseCase
    extends CompletableUseCase<InsertSupplierUseCaseParams> {
  final SupplierRepository _repository;

  InsertSupplierUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      InsertSupplierUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      bool successful = await _repository.insert(params.item);
      if (successful) {
        controller.close();
      } else {
        throw Exception("insert failed");
      }
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
