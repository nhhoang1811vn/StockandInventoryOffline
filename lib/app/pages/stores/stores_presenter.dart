import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Store.dart';
import 'package:good_manager/domain/usecases/stores/get_stores_usecase.dart';

class StoresPresenter extends Presenter{
  Function getStoresOnNext;
  Function getStoresOnComplete;
  Function getStoresOnError;

  GetStoresUseCase _getStoresUseCase;
  StoresPresenter(storeRepository){
    _getStoresUseCase = GetStoresUseCase(storeRepository);
  }
  @override
  void dispose() {
    _getStoresUseCase.dispose();
  }
  void getStores(){
    _getStoresUseCase.execute(_GetStoresUseCaseObserver(this));
  }
}
class _GetStoresUseCaseObserver implements Observer<List<Store>>{
  StoresPresenter _storesPresenter;
  _GetStoresUseCaseObserver(this._storesPresenter);
  @override
  void onComplete() {
    _storesPresenter.getStoresOnComplete();
  }

  @override
  void onError(e) {
    _storesPresenter.getStoresOnError(e);
  }

  @override
  void onNext(response) {
    _storesPresenter.getStoresOnNext(response);
  }
  
}
