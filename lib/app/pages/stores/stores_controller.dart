import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/stores/stores_presenter.dart';
import 'package:good_manager/domain/entities/Store.dart';

class StoresController extends Controller{
  StoresPresenter _storesPresenter;
  List<Store> _stores;
  StoresController(storeRepository) : _storesPresenter = StoresPresenter(storeRepository), super(){
    _stores = [];
    retrieveData();
  }
  void retrieveData() {
    _storesPresenter.getStores();
    //_eventsPresenter.getAllEvents();
  }
  @override
  void initListeners() {
    _storesPresenter.getStoresOnNext = (List<Store> stores) {
      _stores = stores;
    };
    _storesPresenter.getStoresOnError = () {

    };
    _storesPresenter.getStoresOnComplete = () {

    };
  }

}