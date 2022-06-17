import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_store/save_store_presenter.dart';
import 'package:good_manager/domain/entities/store.dart';

class SaveStoreController
    extends BaseSaveItemController<Store, SaveStorePresenter> {
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;

  SaveStoreController(repository, item)
      : super(SaveStorePresenter(repository), item) {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    nameTextController.text = item.name;
    descriptionTextController.text = item.description;
  }

  @override
  void updateItem() {
    item.name = nameTextController.text;
    item.description = descriptionTextController.text;
  }

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
}
