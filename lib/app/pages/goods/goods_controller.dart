import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/goods/add_quantity_good_dialog.dart';
import 'package:good_manager/app/pages/goods/good_item.dart';
import 'package:good_manager/app/pages/goods/goods_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/transaction.dart';

import '../pages.dart';

class GoodsController extends Controller {
  GoodsPresenter presenter;
  List<Group> selectedGroups = [];
  bool isLoading = false;

  bool groupsRetrieved;
  bool goodsRetrieved;

  bool _isSelection;
  DocumentType _documentType;

  List<Group> _groups = [];
  List<Good> _goods = [];
  List<GoodItem> _goodItems = [];

  List<Group> get groups => _groups;

  List<Good> get goods => _goods;

  List<GoodItem> get goodItems => _goodItems;

  bool get isSelection => _isSelection;

  DocumentType get documentType => _documentType;

  List<DocumentTransaction> transactions = [];

  GoodsController(storeRepository, goodRepository, transactionRepository,
      this._isSelection, this._documentType)
      : presenter = GoodsPresenter(
            storeRepository, goodRepository, transactionRepository),
        super() {
    loadData();
  }

  void loadData() {
    isLoading = true;
    groupsRetrieved = goodsRetrieved = false;
    _groups = [];
    _goods = [];

    retrieveGroups();
    retrieveGoods();
  }

  void retrieveGroups() async {
    int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    int groupId = getSelectedGroupId();
    presenter.getGroups(storeId, groupId);
  }

  void retrieveGoods() async {
    int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    int groupId = getSelectedGroupId();
    presenter.getGoods(storeId, groupId);
  }

  void onLoadGroupAndGoodComplete() {
    _goodItems = [];
    this._groups.forEach((element) {
      GoodItem item = GoodItem();
      item.group = element;
      _goodItems.add(item);
    });
    this._goods.forEach((element) {
      GoodItem item = GoodItem();
      item.good = element;
      item.good.pendingQuantity = getPendingQuantity(element.id);
      _goodItems.add(item);
    });
  }

  @override
  void initListeners() {
    presenter.getGroupsOnNext = (groups) {
      this._groups = groups;
    };
    presenter.getGroupsOnComplete = () {
      groupsRetrieved = true;
      if (goodsRetrieved) {
        dismissLoading();
        onLoadGroupAndGoodComplete();
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
        onLoadGroupAndGoodComplete();
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

    final result = await Navigator.of(getContext())
        .pushNamed(Pages.save_good, arguments: {"item": item});
    if (result != null) {
      if (_isSelection) {
        showAddQuantityDialog(result);
      } else {
        loadData();
      }
    }
  }

  void onAddGroup() async {
    Group item = Group();
    item.groupId = getSelectedGroupId();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();

    final result = await Navigator.of(getContext())
        .pushNamed(Pages.save_group, arguments: {"item": item});
    if (result != null) {
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

  void onGroupLongPressed(Group group) {}

  void showAddQuantityDialog(Good good) {
    showDialog(
        context: getContext(),
        builder: (_) => AddQuantityGoodDialog(
              (it) => {onQuantityAdded(good, it)},
            ),
        barrierDismissible: true);
  }

  void onGoodTapped(Good good) async {
    if (this._isSelection) {
      showAddQuantityDialog(good);
    } else {
      final result = await Navigator.of(getContext())
          .pushNamed(Pages.save_good, arguments: {"item": good});
      if (result != null) {
        loadData();
      }
    }
  }

  void onQuantityAdded(Good good, int quantity) {
    DocumentTransaction transaction = DocumentTransaction();
    transaction.goodId = good.id;
    transaction.quantity = quantity;

    good.quantity = quantity;
    transaction.good = good;

    transactions.add(transaction);

    loadData();
  }

  void onGoodLongPressed(Good good) {}

  int getPendingQuantity(int goodId) {
    int quantity = 0;
    transactions.forEach((transaction) {
      if (transaction.goodId == goodId) {
        quantity += transaction.quantity;
      }
    });
    return quantity;
  }
}
