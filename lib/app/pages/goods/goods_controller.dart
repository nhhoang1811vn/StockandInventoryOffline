import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/goods/goods_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/group.dart';

import '../pages.dart';

class GoodsController extends Controller {
  GoodsPresenter presenter;
  List<Group> selectedGroups = [];
  bool isLoading = false;

  bool groupsRetrieved;
  bool goodsRetrieved;


  List<Group> _groups = [];
  List<Good> _goods = [];

  List<Group> get groups => _groups;
  List<Good> get goods => _goods;
  GoodsController(storeRepository, goodRepository)
      : presenter = GoodsPresenter(storeRepository, goodRepository),
        super() {
    loadData();
  }
  void loadData(){
    isLoading = true;
    groupsRetrieved = goodsRetrieved = false;
    _groups = [];
    _goods = [];
    retrieveGroups();
    retrieveGoods();
  }
  void retrieveGroups() async{
    int storeId =  await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    int groupId = getSelectedGroupId();
    presenter.getGroups(storeId, groupId);
  }
  void retrieveGoods() async{
    int storeId =  await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    int groupId = getSelectedGroupId();
    presenter.getGoods(storeId, groupId);
  }

  @override
  void initListeners() {
    presenter.getGroupsOnNext = (groups){
      this._groups = groups;
    };
    presenter.getGroupsOnComplete = (){
      groupsRetrieved = true;
      if (goodsRetrieved){
        dismissLoading();
      }
    };
    presenter.getGroupsOnError = (e){
      showErrorToast(e.message);
    };

    presenter.getGoodsOnNext = (goods){
      this._goods = goods;
    };
    presenter.getGoodsOnComplete = (){
      goodsRetrieved = true;
      if (groupsRetrieved){
        dismissLoading();
      }
    };
    presenter.getGoodsOnError = (e){
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

  void onAddGood() async{
    Good item = Good();
    item.groupId = getSelectedGroupId();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();

    final result = await Navigator.of(getContext()).pushNamed(Pages.save_good,
        arguments: {"isInsert": true, "item": item});
    if (result){
      loadData();
    }
  }

  void onAddGroup() async {
    Group item = Group();
    item.groupId = getSelectedGroupId();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();

    final result = await Navigator.of(getContext()).pushNamed(Pages.save_group,
        arguments: {"isInsert": true, "item": item});
    if (result){
      loadData();
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
    loadData();
    refreshUI();

  }
  void onGroupTapped(Group group) {
    selectedGroups.add(group);
    loadData();
    refreshUI();
  }
  void onGroupLongPressed(Group group){

  }
  void onGoodTapped(Good good){

  }
  void onGoodLongPressed(Good good){

  }
}
