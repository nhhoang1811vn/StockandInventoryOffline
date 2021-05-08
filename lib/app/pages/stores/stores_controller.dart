import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/stores/stores_presenter.dart';
import 'package:good_manager/domain/entities/Store.dart';

class StoresController extends Controller{
  bool isLoading = false;
  StoresPresenter _storesPresenter;
  List<Store> _stores;

  List<Store> get stores => _stores;
  StoresController(storeRepository) : _storesPresenter = StoresPresenter(storeRepository), super(){
    _stores = [];
    isLoading = true;
    retrieveData();
  }
  void retrieveData() {
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

  void onAddStore(){
    Navigator.of(getContext()).pushNamed(Pages.save_store, arguments: {
      'store': Store.init(),
      'isInsert' : true
    });
  }
  void onEditStore(Store store){
    Navigator.of(getContext()).pushNamed(Pages.save_store, arguments: {
      'store': store,
      'isInsert' : false
    });
  }
  void openHelpPage(){
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      'content' : "abc"
    });
  }

  @override
  void dispose() {
    _storesPresenter.dispose();
    super.dispose();
  }
}