import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class DeleteSupplierUseCase
    extends CompletableUseCase<DeleteSupplierUseCaseParams> {
  final SupplierRepository _supplierRepository;

  DeleteSupplierUseCase(this._supplierRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      DeleteSupplierUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      await _supplierRepository.delete(params.id);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class DeleteSupplierUseCaseParams {
  final int id;

  DeleteSupplierUseCaseParams(this.id);
}
