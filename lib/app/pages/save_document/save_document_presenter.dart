import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/usecases/app/get_barcode_scanner_settings_usecase.dart';
import 'package:good_manager/domain/usecases/documents/insert_document_usecase.dart';
import 'package:good_manager/domain/usecases/documents/update_document_usecase.dart';
import 'package:good_manager/domain/usecases/goods/get_good_by_barcode_usecase.dart';
import 'package:good_manager/domain/usecases/transaction/get_transactions_by_document_id_usecase.dart';

class SaveDocumentPresenter extends Presenter {
  Function insertDocumentOnNext;
  Function insertDocumentOnError;

  Function updateDocumentOnComplete;
  Function updateDocumentOnError;

  Function getTransactionsByDocumentIdOnNext;
  Function getTransactionsByDocumentIdOnError;

  Function getGoodByBarcodeOnNext;
  Function getGoodByBarcodeOnError;

  Function getBarcodeScannerSettingsOnNext;
  Function getBarcodeScannerSettingsOnError;

  InsertDocumentUseCase insertDocumentUseCase;
  UpdateDocumentUseCase updateDocumentUseCase;
  GetTransactionsByDocumentIdUseCase getTransactionsByDocumentIdUseCase;
  GetGoodByBarcodeUseCase getGoodByBarcodeUseCase;

  GetBarcodeScannerSettingsUseCase getBarcodeScannerSettingsUseCase;

  SaveDocumentPresenter(_appRepository, _documentRepository,
      _transactionRepository, _goodRepository) {
    insertDocumentUseCase = InsertDocumentUseCase(_documentRepository);
    updateDocumentUseCase = UpdateDocumentUseCase(_documentRepository);
    getTransactionsByDocumentIdUseCase =
        GetTransactionsByDocumentIdUseCase(_transactionRepository);

    getGoodByBarcodeUseCase = GetGoodByBarcodeUseCase(_goodRepository);
    getBarcodeScannerSettingsUseCase =
        GetBarcodeScannerSettingsUseCase(_appRepository);
  }

  @override
  void dispose() {
    insertDocumentUseCase.dispose();
    updateDocumentUseCase.dispose();
    getTransactionsByDocumentIdUseCase.dispose();
    getGoodByBarcodeUseCase.dispose();
    getBarcodeScannerSettingsUseCase.dispose();
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

  void getGoodByBarcode(String barcode) => getGoodByBarcodeUseCase.execute(
      GetGoodByBarcodeUseCaseObserver(this),
      GetGoodByBarcodeUseCaseParams(barcode));

  void getBarcodeScannerSettings() => getBarcodeScannerSettingsUseCase
      .execute(GetBarcodeScannerSettingsUseCaseObserver(this));
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

class GetGoodByBarcodeUseCaseObserver implements Observer<Good> {
  SaveDocumentPresenter _presenter;

  GetGoodByBarcodeUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getGoodByBarcodeOnError(e);
  }

  @override
  void onNext(Good good) {
    _presenter.getGoodByBarcodeOnNext(good);
  }
}

class GetBarcodeScannerSettingsUseCaseObserver
    implements Observer<BarcodeScannerSettings> {
  final SaveDocumentPresenter presenter;

  GetBarcodeScannerSettingsUseCaseObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getBarcodeScannerSettingsOnError(e);
  }

  @override
  void onNext(BarcodeScannerSettings response) {
    presenter.getBarcodeScannerSettingsOnNext(response);
  }
}
