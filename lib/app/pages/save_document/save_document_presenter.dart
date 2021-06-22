import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/usecases/documents/insert_document_usecase.dart';
import 'package:good_manager/domain/usecases/documents/update_document_usecase.dart';
import 'package:good_manager/domain/usecases/transaction/get_transactions_by_document_id_usecase.dart';

class SaveDocumentPresenter extends Presenter {
  Function insertDocumentOnNext;
  Function insertDocumentOnError;

  Function updateDocumentOnComplete;
  Function updateDocumentOnError;

  Function getTransactionsByDocumentIdOnNext;
  Function getTransactionsByDocumentIdOnError;

  InsertDocumentUseCase insertDocumentUseCase;
  UpdateDocumentUseCase updateDocumentUseCase;
  GetTransactionsByDocumentIdUseCase getTransactionsByDocumentIdUseCase;

  SaveDocumentPresenter(_documentRepository, _transactionRepository) {
    insertDocumentUseCase =
        InsertDocumentUseCase(_documentRepository, _transactionRepository);
    updateDocumentUseCase =
        UpdateDocumentUseCase(_documentRepository, _transactionRepository);
    getTransactionsByDocumentIdUseCase =
        GetTransactionsByDocumentIdUseCase(_transactionRepository);
  }

  @override
  void dispose() {
    insertDocumentUseCase.dispose();
    updateDocumentUseCase.dispose();
    getTransactionsByDocumentIdUseCase.dispose();
  }

  void insert(Document document, List<DocumentTransaction> transactions) =>
      insertDocumentUseCase.execute(_InsertDocumentUseCaseObserver(this),
          InsertDocumentUseCaseParams(document, transactions));

  void update(Document document, List<DocumentTransaction> transactions) =>
      updateDocumentUseCase.execute(_UpdateDocumentUseCaseObserver(this),
          UpdateDocumentUseCaseParams(document, transactions));

  void getTransactionByDocumentId(int documentId) =>
      getTransactionsByDocumentIdUseCase.execute(
          GetTransactionsByDocumentIdUseCaseObserver(this),
          GetTransactionsByDocumentIdUseCaseParams(documentId));
}

class _InsertDocumentUseCaseObserver implements Observer<int> {
  SaveDocumentPresenter _presenter;

  _InsertDocumentUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.insertDocumentOnError(e);
  }

  @override
  void onNext(int documentId) {
    _presenter.insertDocumentOnNext(documentId);
  }
}

class _UpdateDocumentUseCaseObserver implements Observer<void> {
  SaveDocumentPresenter _presenter;

  _UpdateDocumentUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateDocumentOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateDocumentOnError(e);
  }

  @override
  void onNext(void response) {}
}

class GetTransactionsByDocumentIdUseCaseObserver
    implements Observer<List<DocumentTransaction>> {
  SaveDocumentPresenter _presenter;

  GetTransactionsByDocumentIdUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getTransactionsByDocumentIdOnError(e);
  }

  @override
  void onNext(List<DocumentTransaction> transactions) {
    _presenter.getTransactionsByDocumentIdOnNext(transactions);
  }
}
