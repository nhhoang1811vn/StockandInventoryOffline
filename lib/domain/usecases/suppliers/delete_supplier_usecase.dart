import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';

class DeleteSupplierUseCase
    extends UseCase<DeleteSupplierUseCaseResult, DeleteSupplierUseCaseParams> {
  final SupplierRepository _supplierRepository;
  final DocumentRepository _documentRepository;

  DeleteSupplierUseCase(this._supplierRepository, this._documentRepository);

  @override
  Future<Stream<DeleteSupplierUseCaseResult>> buildUseCaseStream(
      DeleteSupplierUseCaseParams params) async {
    final StreamController<DeleteSupplierUseCaseResult> controller =
        StreamController();
    try {
      var list = await _documentRepository.findBySupplierId(params.id);
      if (list.isEmpty) {
        bool successful = await _supplierRepository.delete(params.id);
        if (successful) {
          controller.add(DeleteSupplierUseCaseResult.success);
        } else {
          controller.add(DeleteSupplierUseCaseResult.un_success_row_effect);
        }
        controller.close();
      } else {
        controller.add(DeleteSupplierUseCaseResult.un_success_have_document);
        controller.close();
      }
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

enum DeleteSupplierUseCaseResult {
  success,
  un_success_have_document,
  un_success_row_effect
}

class DeleteSupplierUseCaseParams {
  final int id;

  DeleteSupplierUseCaseParams(this.id);
}