import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/usecases/insert_supplier_usecase.dart';
import 'package:good_manager/domain/usecases/update_supplier_usecase.dart';

class SaveSupplierPresenter extends Presenter{
  Function insertSupplierOnComplete;
  Function insertSupplierOnError;

  InsertSupplierUseCase _insertSupplierUseCase;
  UpdateSupplierUseCase _updateSupplierUseCase;
  SaveSupplierPresenter(supplierRepository){
    _insertSupplierUseCase = InsertSupplierUseCase(supplierRepository);
    //_updateSupplierUseCase = UpdateSupplierUseCase(supplierRepository);
  }

  insert(Supplier item) => _insertSupplierUseCase.execute(_InsertSupplierUseCaseObserver(this), InsertSupplierUseCaseParams(item));
  //update(Supplier item) => updateSupplierUseCase.execute(observer)

  @override
  void dispose() {
    _insertSupplierUseCase.dispose();
    //_updateSupplierUseCase.dispose();
  }

}
class _InsertSupplierUseCaseObserver implements Observer<void>{
  SaveSupplierPresenter _presenter;
  _InsertSupplierUseCaseObserver(this._presenter);
  @override
  void onComplete() {
    _presenter.insertSupplierOnComplete();
  }

  @override
  void onError(e) {
    _presenter.insertSupplierOnError(e);
  }

  @override
  void onNext(void response) {
  }
}