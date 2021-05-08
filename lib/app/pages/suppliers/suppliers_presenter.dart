import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/usecases/get_suppliers_usecase.dart';

class SuppliersPresenter extends Presenter{
  Function getSuppliersOnNext;
  Function getSuppliersOnComplete;
  Function getSuppliersOnError;

  GetSuppliersUseCase _getSuppliersUseCase;
  SuppliersPresenter(supplierRepository){
    _getSuppliersUseCase = GetSuppliersUseCase(supplierRepository);
  }
  @override
  void dispose() {
    _getSuppliersUseCase.dispose();
  }
  void getSuppliers(){
    _getSuppliersUseCase.execute(_GetSuppliersUseCaseObserver(this));
  }
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
