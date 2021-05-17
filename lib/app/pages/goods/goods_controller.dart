import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/goods/goods_presenter.dart';
import 'package:good_manager/domain/entities/group.dart';

import '../pages.dart';

class GoodsController extends Controller {
  GoodsPresenter presenter;

  GoodsController()
      : presenter = GoodsPresenter(),
        super() {}

  @override
  void initListeners() {}

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  void onAddGood() {
    //Good item = Good();
    //item.groupId = getSelectedGroupId();
    //item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();

    //SaveGoodPageArguments arguments = SaveGoodPageArguments();
    //arguments.good = item;
    //final result = await Navigator.of(context)
    //    .pushNamed(Pages.save_good, arguments: arguments);
    //if (result) {
    //  screenUpdated();
    //}
    //Navigator.of(getContext()).pushNamed(Pages.save_group);
  }

  void onAddGroup() async {
    Group item = Group();
    //item.groupId = getSelectedGroupId();
    //item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    //final result = await Navigator.of(context).pushNamed(Pages.save_group,
    //    arguments: SaveGroupPageArguments(true, item));
    //if (result) {
    //  screenUpdated();
    //}
    final result = await Navigator.of(getContext()).pushNamed(Pages.save_group,
        arguments: {"isInsert": true, "item": item});
  }
}
