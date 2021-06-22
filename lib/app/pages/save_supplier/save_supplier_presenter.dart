import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/usecases/suppliers/insert_supplier_usecase.dart';
import 'package:good_manager/domain/usecases/suppliers/update_supplier_usecase.dart';

class SaveSupplierPresenter extends Presenter {
  Function insertSupplierOnNext;
  Function insertSupplierOnError;

  Function updateSupplierOnComplete;
  Function updateSupplierOnError;

  InsertSupplierUseCase _insertSupplierUseCase;
  UpdateSupplierUseCase _updateSupplierUseCase;

  SaveSupplierPresenter(supplierRepository) {
    _insertSupplierUseCase = InsertSupplierUseCase(supplierRepository);
    _updateSupplierUseCase = UpdateSupplierUseCase(supplierRepository);
  }

  insert(Supplier item) => _insertSupplierUseCase.execute(
      _InsertSupplierUseCaseObserver(this), InsertSupplierUseCaseParams(item));

  update(Supplier item) => _updateSupplierUseCase.execute(
      _UpdateSupplierUseCaseObserver(this), UpdateSupplierUseCaseParams(item));

  @override
  void dispose() {
    _insertSupplierUseCase.dispose();
    _updateSupplierUseCase.dispose();
  }
}

class _InsertSupplierUseCaseObserver implements Observer<int> {
  SaveSupplierPresenter _presenter;

  _InsertSupplierUseCaseObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.insertSupplierOnError(e);
  }

  @override
  void onNext(int supplierId) {
    _presenter.insertSupplierOnNext(supplierId);
  }
}

class _UpdateSupplierUseCaseObserver implements Observer<void> {
  SaveSupplierPresenter _presenter;

  _UpdateSupplierUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateSupplierOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateSupplierOnError(e);
  }

  @override
  void onNext(void response) {}
}