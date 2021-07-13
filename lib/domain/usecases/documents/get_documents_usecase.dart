/*import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';

class GetDocumentsUseCase
    extends UseCase<List<Document>, GetDocumentsUseCaseParams> {
  final DocumentRepository _repository;

  GetDocumentsUseCase(this._repository);

  @override
  Future<Stream<List<Document>>> buildUseCaseStream(
      GetDocumentsUseCaseParams params) async {
    final StreamController<List<Document>> controller = StreamController();
    try {
      List<Document> items = await _repository.getDocuments(params.storeId);
      controller.add(items);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}*/
