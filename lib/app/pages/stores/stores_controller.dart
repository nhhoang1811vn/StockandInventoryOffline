import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/stores/stores_presenter.dart';
import 'package:good_manager/domain/entities/Store.dart';

class StoresController extends Controller{
  bool isLoading = false;
  StoresPresenter _storesPresenter;
  List<Store> _stores;
  StoresController(storeRepository) : _storesPresenter = StoresPresenter(storeRepository), super(){
    _stores = [];
    isLoading = false;
    retrieveData();
  }
  void retrieveData() {
    isLoading = true;
    refreshUI();
    _storesPresenter.getStores();
  }
  @override
  void initListeners() {
    _storesPresenter.getStoresOnNext = (List<Store> stores) {
      _stores = stores;
    };
    _storesPresenter.getStoresOnError = (e) {
      handleError(e);
    };
    _storesPresenter.getStoresOnComplete = () {
      dismissLoading();
    };
  }
  void dismissLoading(){
    isLoading = false;
    refreshUI();
  }
  void handleError(e){
    dismissLoading();
  }

}