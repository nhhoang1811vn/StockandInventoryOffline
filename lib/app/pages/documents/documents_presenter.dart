import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_settings.dart';
import 'package:good_manager/domain/usecases/base_get_settings_usecase.dart';
import 'package:good_manager/domain/usecases/base_set_settings_usecase.dart';
import 'package:good_manager/domain/usecases/documents/delete_document_usecase.dart';
import 'package:good_manager/domain/usecases/documents/get_documents_usecase.dart';

class DocumentsPresenter extends Presenter {
  int deletedId;
  Function getDocumentsOnNext;
  Function getDocumentsOnError;

  Function deleteDocumentOnComplete;
  Function deleteDocumentOnError;

  //get setting
  Function getDocumentSettingsOnNext;
  Function getDocumentSettingsOnError;

  //set setting
  Function setDocumentSettingsOnComplete;
  Function setDocumentSettingsOnError;

  GetDocumentsUseCase getItemsUseCase;
  DeleteDocumentUseCase deleteDocumentUseCase;

  BaseGetSettingsUseCase<DocumentSettings> getSettingsUseCase;
  BaseSetSettingsUseCase<DocumentSettings> setSettingsUseCase;

  DocumentsPresenter(documentRepository, transactionRepository) {
    getItemsUseCase = GetDocumentsUseCase(documentRepository);
    deleteDocumentUseCase =
        DeleteDocumentUseCase(documentRepository, transactionRepository);

    getSettingsUseCase = BaseGetSettingsUseCase(documentRepository);
    setSettingsUseCase = BaseSetSettingsUseCase(documentRepository);
  }

  Future<String> getAutoDocumentName() async {
    return appDataManager.sharedPrefsHelper.getAutoDocumentName();
  }

  void getDocuments(int storeId) => getItemsUseCase.execute(
      GetDocumentsObserver(this), GetDocumentsUseCaseParams(storeId));

  void delete(int documentId) {
    deletedId = documentId;
    deleteDocumentUseCase.execute(
        DeleteDocumentsObserver(this), DeleteDocumentUseCaseParams(documentId));
  }

  void getSettings() =>
      getSettingsUseCase.execute(GetDocumentSettingsObserver(this));

  void setSettings(DocumentSettings settings) => setSettingsUseCase.execute(
      SetDocumentSettingsObserver(this), BaseSetSettingsUseCaseParam(settings));

  @override
  void dispose() {
    getItemsUseCase.dispose();
    deleteDocumentUseCase.dispose();
    getSettingsUseCase.dispose();
    setSettingsUseCase.dispose();
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

class GetDocumentSettingsObserver implements Observer<DocumentSettings> {
  DocumentsPresenter presenter;

  GetDocumentSettingsObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getDocumentSettingsOnError(e);
  }

  @override
  void onNext(DocumentSettings response) {
    presenter.getDocumentSettingsOnNext(response);
  }
}

class SetDocumentSettingsObserver implements Observer<void> {
  DocumentsPresenter presenter;

  SetDocumentSettingsObserver(this.presenter);

  @override
  void onComplete() {
    presenter.setDocumentSettingsOnComplete();
  }

  @override
  void onError(e) {
    presenter.setDocumentSettingsOnError(e);
  }

  @override
  void onNext(void response) {}
}
