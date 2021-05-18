import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/goods/goods_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/group.dart';

import '../pages.dart';

class GoodsController extends Controller {
  GoodsPresenter presenter;
  List<Group> selectedGroups = [];
  bool isLoading = false;
  List<Group> _groups = [];

  List<Group> get groups => _groups;
  GoodsController(storeRepository)
      : presenter = GoodsPresenter(storeRepository),
        super() {
    loadData();
  }
  void loadData(){
    isLoading = true;
    retrieveGroups();
    retrieveGoods();
  }
  void retrieveGroups() async{
    int storeId =  await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    int groupId = getSelectedGroupId();
    presenter.getGroups(storeId, groupId);
  }
  void retrieveGoods(){

  }

  @override
  void initListeners() {
    presenter.getGroupsOnNext = (groups){
      this._groups = groups;
    };
    presenter.getGroupsOnComplete = (){
      dismissLoading();
    };
    presenter.getGroupsOnError = (e){
      showErrorToast(e.message);
    };
  }
  void dismissLoading() {
    isLoading = false;
    refreshUI();
  }

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
    item.groupId = getSelectedGroupId();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    //final result = await Navigator.of(context).pushNamed(Pages.save_group,
    //    arguments: SaveGroupPageArguments(true, item));
    //if (result) {
    //  screenUpdated();
    //}
    final result = await Navigator.of(getContext()).pushNamed(Pages.save_group,
        arguments: {"isInsert": true, "item": item});
    if (result){
      isLoading = true;
      retrieveGroups();
      retrieveGoods();
    }
  }
  void openHelpPage(){
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title" : "Stores",
      "content" : "Help of store content"
    });
  }
  int getSelectedGroupId() {
    if (selectedGroups.isEmpty) {
      return null;
    } else {
      return selectedGroups.last.id;
    }
  }
  void onSelectedGroupTapped(int index) {
    if (index == -1) {
      selectedGroups.clear();
    } else {
      selectedGroups = selectedGroups.sublist(0, index + 1);
    }
    refreshUI();
  }
  void onGroupTapped(Group group) {
    selectedGroups.add(group);
    refreshUI();
    loadData();
  }
}
