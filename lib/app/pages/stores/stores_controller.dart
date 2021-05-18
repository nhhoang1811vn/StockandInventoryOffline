import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/stores/stores_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/store.dart';

class StoresController extends Controller{
  bool isLoading = false;
  StoresPresenter _storesPresenter;
  List<Store> _stores;

  List<Store> get stores => _stores;
  StoresController(storeRepository) : _storesPresenter = StoresPresenter(storeRepository), super(){
    _stores = [];
    retrieveData();
  }
  void retrieveData() {
    isLoading = true;
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
    showErrorToast(e.message);
  }

  void onAddStore() async{
    final result = await Navigator.of(getContext()).pushNamed(Pages.save_store, arguments: {
      'isInsert' : true
    });
    if (result){
      retrieveData();
    }
  }
  void onEditStore(Store store) async{
    //TODO
    appDataManager.sharedPrefsHelper.setSelectedStoreId(store.id);
    final result = await Navigator.of(getContext()).pushNamed(Pages.save_store, arguments: {
      'store': store,
      'isInsert' : false
    });
    if (result){
      retrieveData();
    }
  }
  void openHelpPage(){
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title" : "Stores",
      "content" : "Help of store content"
    });
  }

  @override
  void dispose() {
    _storesPresenter.dispose();
    super.dispose();
  }
}