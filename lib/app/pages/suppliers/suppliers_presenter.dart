import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/entities/SupplierSettings.dart';
import 'package:good_manager/domain/usecases/suppliers/delete_supplier_usecase.dart';
import 'package:good_manager/domain/usecases/suppliers/get_supplier_settings_usecase.dart';
import 'package:good_manager/domain/usecases/suppliers/get_suppliers_usecase.dart';
import 'package:good_manager/domain/usecases/suppliers/set_supplier_settings_usecase.dart';

class SuppliersPresenter extends Presenter {
  Function getSuppliersOnNext;
  Function getSuppliersOnComplete;
  Function getSuppliersOnError;

  Function getSupplierSettingsOnNext;
  Function getSupplierSettingsOnComplete;
  Function getSupplierSettingsOnError;

  Function setSupplierSettingsOnComplete;
  Function setSupplierSettingsOnError;

  //Delete Supplier
  Function deleteSupplierOnNext;
  Function deleteSupplierOnComplete;
  Function deleteSupplierOnError;

  GetSuppliersUseCase _getSuppliersUseCase;
  GetSupplierSettingsUseCase _getSupplierSettingsUseCase;
  SetSupplierSettingsUseCase _setSupplierSettingsUseCase;
  DeleteSupplierUseCase _deleteSupplierUseCase;

  SuppliersPresenter(_supplierRepository, _documentRepository) {
    _getSuppliersUseCase = GetSuppliersUseCase(_supplierRepository);
    _getSupplierSettingsUseCase =
        GetSupplierSettingsUseCase(_supplierRepository);
    _setSupplierSettingsUseCase =
        SetSupplierSettingsUseCase(_supplierRepository);

    _deleteSupplierUseCase =
        DeleteSupplierUseCase(_supplierRepository, _documentRepository);
  }

  @override
  void dispose() {
    _getSuppliersUseCase.dispose();
    _getSupplierSettingsUseCase.dispose();
    _setSupplierSettingsUseCase.dispose();
    _deleteSupplierUseCase.dispose();
  }

  void getSuppliers() =>
      _getSuppliersUseCase.execute(_GetSuppliersUseCaseObserver(this));

  void getSettings() => _getSupplierSettingsUseCase
      .execute(_GetSupplierSettingsUseCaseObserver(this));

  void setSettings(SupplierSettings settings) =>
      _setSupplierSettingsUseCase.execute(
          _SetSupplierSettingsUseCaseObserver(this),
          SetSupplierSettingsUseCaseParams(settings));

  void delete(int id) => _deleteSupplierUseCase.execute(
      _DeleteSupplierUseCaseObserver(this), DeleteSupplierUseCaseParams((id)));
}

class _GetSuppliersUseCaseObserver implements Observer<List<Supplier>>{
  SuppliersPresenter _presenter;
  _GetSuppliersUseCaseObserver(this._presenter);
  @override
  void onComplete() {
    _presenter.getSuppliersOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getSuppliersOnError(e);
  }

  @override
  void onNext(List<Supplier> response) {
    _presenter.getSuppliersOnNext(response);
  }
}

class _GetSupplierSettingsUseCaseObserver
    implements Observer<SupplierSettings> {
  SuppliersPresenter _presenter;

  _GetSupplierSettingsUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getSupplierSettingsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getSupplierSettingsOnError(e);
  }

  @override
  void onNext(SupplierSettings response) {
    _presenter.getSupplierSettingsOnNext(response);
  }
}

class _SetSupplierSettingsUseCaseObserver implements Observer<void> {
  SuppliersPresenter _presenter;

  _SetSupplierSettingsUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.setSupplierSettingsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.setSupplierSettingsOnError(e);
  }

  @override
  void onNext(void response) {}
}

class _DeleteSupplierUseCaseObserver
    implements Observer<DeleteSupplierUseCaseResult> {
  SuppliersPresenter _presenter;

  _DeleteSupplierUseCaseObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.deleteSupplierOnComplete();
  }

  @override
  void onError(e) {
    _presenter.deleteSupplierOnError(e);
  }

  @override
  void onNext(DeleteSupplierUseCaseResult response) {
    _presenter.deleteSupplierOnNext(response);
  }
}
