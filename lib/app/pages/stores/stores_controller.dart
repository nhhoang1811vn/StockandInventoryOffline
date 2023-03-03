import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/stores/stores_presenter.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/stores_settings.dart';

import '../base/base_list_controller.dart';
import '../help_content.dart';

class StoresController
    extends BaseListController<Store, StoresSettings, StoresPresenter> {
  StoresController(repository, isSelection)
      : super(StoresPresenter(repository), isSelection);

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

  @override
  HelpType getHelpType() {
    return HelpType.STORE;
  }

  @override
  String getTitle() {
    return AppLocalizations.of(getContext()).stores_title;
  }
  @override
  void onItemPressed(Store item) {
    if (this.isSelection){
      Navigator.of(getContext()).pop(item);
    }else{
      super.onItemPressed(item);
    }
  }
}