import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/stores/stores_presenter.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/stores_settings.dart';

import '../base_list_controller.dart';

class StoresController
    extends BaseListController<Store, StoresSettings, StoresPresenter> {
  StoresController(repository) : super(StoresPresenter(repository));

  void onOpenHelpPage() {
    Navigator.of(getContext()).pushNamed(Pages.help,
        arguments: {"title": "Stores", "content": "Help of store content"});
  }

  @override
  bool filterItem(Store item, String textSearch) {
    return item.name.contains(textSearch);
  }

  @override
  Store getEmptyItem() {
    return Store();
  }

  @override
  String getSaveItemRouteName() {
    return Pages.save_store;
  }
}