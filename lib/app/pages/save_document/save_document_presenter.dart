import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/usecases/documents/insert_document_usecase.dart';

class SaveDocumentPresenter extends Presenter {
  InsertDocumentUseCase insertDocumentUseCase;

  SaveDocumentPresenter(_documentRepository, _transactionRepository) {
    insertDocumentUseCase =
        InsertDocumentUseCase(_documentRepository, _transactionRepository);
  }

  @override
  void dispose() {
    insertDocumentUseCase.dispose();
  }
}
