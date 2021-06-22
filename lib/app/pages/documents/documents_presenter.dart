import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/usecases/documents/delete_document_usecase.dart';
import 'package:good_manager/domain/usecases/documents/get_documents_usecase.dart';

class DocumentsPresenter extends Presenter {
  int deletedId;
  Function getDocumentsOnNext;
  Function getDocumentsOnError;

  Function deleteDocumentOnComplete;
  Function deleteDocumentOnError;

  GetDocumentsUseCase getDocumentsUseCase;
  DeleteDocumentUseCase deleteDocumentUseCase;

  DocumentsPresenter(documentRepository) {
    getDocumentsUseCase = GetDocumentsUseCase(documentRepository);
    deleteDocumentUseCase = DeleteDocumentUseCase(documentRepository);
  }

  Future<String> getAutoDocumentName() async {
    return appDataManager.sharedPrefsHelper.getAutoDocumentName();
  }

  void getDocuments(int storeId) => getDocumentsUseCase.execute(
      GetDocumentsObserver(this), GetDocumentsUseCaseParams(storeId));

  void delete(int documentId) {
    deletedId = documentId;
    deleteDocumentUseCase.execute(
        DeleteDocumentsObserver(this), DeleteDocumentUseCaseParams(documentId));
  }

  @override
  void dispose() {
    getDocumentsUseCase.dispose();
    deleteDocumentUseCase.dispose();
  }
}

class GetDocumentsObserver implements Observer<List<Document>> {
  DocumentsPresenter presenter;

  GetDocumentsObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getDocumentsOnError(e);
  }

  @override
  void onNext(List<Document> response) {
    presenter.getDocumentsOnNext(response);
  }
}

class DeleteDocumentsObserver implements Observer<void> {
  DocumentsPresenter presenter;

  DeleteDocumentsObserver(this.presenter);

  @override
  void onComplete() {
    presenter.deleteDocumentOnComplete();
  }

  @override
  void onError(e) {
    presenter.deleteDocumentOnError(e);
  }

  @override
  void onNext(void response) {}
}
