/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/base/base_save_item_controller.dart';
import 'package:good_manager/presentation/pages/save_store/save_store_presenter.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/store.dart';

class SaveStoreController
    extends BaseSaveItemController<Store, SaveStorePresenter> {
  SaveStoreController(repository, item)
      : super(SaveStorePresenter(repository), item);

  @override
  Store getOriginalItem(Store item) {
    Store store = Store();
    store.name = item.name;
    store.description = item.description;
    return store;
  }

  @override
  bool hasChanged(Store item, Store originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description);
  }
  @override
  void initListeners(){
    super.initListeners();
    presenter.updateItemOnComplete = () async {
      int selectedStoreId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
      if (item.id == selectedStoreId){
        appDataManager.sharedPrefsHelper.setSelectedStoreName(item.name);
      }
      Navigator.of(getContext()).pop(item);
    };
  }
}
*/
