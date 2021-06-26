import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/goods/add_quantity_good_dialog.dart';
import 'package:good_manager/app/pages/goods/goods_presenter.dart';
import 'package:good_manager/app/pages/goods/sort_goods_dialog.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/search_goods_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/entities/transaction.dart';

import '../pages.dart';

class GoodsController extends Controller {
  TextEditingController searchTextController;
  GoodsPresenter presenter;
  List<Group> selectedGroups = [];
  bool isLoading = false;

  bool groupsRetrieved;
  bool goodsRetrieved;

  bool _isSelection;
  DocumentType _documentType;
  List<Group> _allGroups = [];
  List<Good> _allGoods = [];

  List<Group> _groups = [];
  List<Good> _goods = [];

  List<Group> get groups => _groups;

  List<Good> get goods => _goods;

  bool get isSelection => _isSelection;

  DocumentType get documentType => _documentType;

  List<DocumentTransaction> transactions = [];

  bool showSearchBar = false;
  String _textSearch = "";

  String get textSearch => _textSearch;

  GoodsSettings _settings;

  GoodsController(storeRepository, goodRepository, transactionRepository,
      this._isSelection, this._documentType)
      : presenter = GoodsPresenter(
            storeRepository, goodRepository, transactionRepository),
        super() {
    searchTextController = TextEditingController();
    isLoading = true;
    retrieveSettings();
  }

  void loadData() {
    isLoading = true;
    groupsRetrieved = goodsRetrieved = false;
    _allGroups = [];
    _allGoods = [];

    _groups = [];
    _goods = [];

    retrieveGroups();
    retrieveGoods();
  }

  void retrieveSettings() {
    presenter.getSettings();
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

  void refreshItems() {
    sort();
    filter();
    this._goods.forEach((element) {
      element.pendingQuantity = getPendingQuantity(element.id);
    });
    refreshUI();
  }

  @override
  void initListeners() {
    presenter.getGroupsOnNext = (groups) {
      this._allGroups = groups;
    };
    presenter.getGroupsOnComplete = () {
      groupsRetrieved = true;
      if (goodsRetrieved) {
        isLoading = false;
        refreshItems();
      }
    };
    presenter.getGroupsOnError = (e) {
      showErrorToast(e.message.toString());
    };

    presenter.getGoodsOnNext = (goods) {
      _allGoods = goods;
    };
    presenter.getGoodsOnComplete = () {
      goodsRetrieved = true;
      if (groupsRetrieved) {
        isLoading = false;
        refreshItems();
      }
    };
    presenter.getGoodsOnError = (e) {
      showErrorToast(e.message.toString());
    };

    presenter.getGoodsSettingsOnNext = (settings) {
      this._settings = settings;
      loadData();
    };
    presenter.getGoodsSettingsOnError = (e) {
      showErrorToast(e.message.toString());
    };
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  void onAddGood() async {
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

  void openHelpPage() {
    Navigator.of(getContext()).pushNamed(Pages.help,
        arguments: {"title": "Stores", "content": "Help of store content"});
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

  void onGroupLongPressed(Group group) {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  //showDeleteDocumentConfirm(item);
                },
                child: Text(
                    AppLocalizations.of(getContext()).action_move_to_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  onEditGroup(group);
                  //showDeleteDocumentConfirm(item);
                },
                child:
                    Text(AppLocalizations.of(getContext()).action_edit_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  //showDeleteDocumentConfirm(item);
                },
                child:
                    Text(AppLocalizations.of(getContext()).action_delete_group),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }

  void onEditGroup(Group group) async {
    final result = await Navigator.of(getContext())
        .pushNamed(Pages.save_group, arguments: {"item": group});
    if (result != null) {
      loadData();
    }
  }

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

  void onShowSortDialog() async {
    showDialog(
        context: getContext(),
        builder: (_) => SortGoodsDialog(_settings, () {
              presenter.setSettings(_settings);
              refreshItems();
            }),
        barrierDismissible: true);
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

  void onGoodLongPressed(Good good) {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  //showDeleteDocumentConfirm(item);
                },
                child: Text(
                    AppLocalizations.of(getContext()).action_move_to_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  //showDeleteDocumentConfirm(item);
                },
                child: Text(AppLocalizations.of(getContext()).action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }

  int getPendingQuantity(int goodId) {
    int quantity = 0;
    transactions.forEach((transaction) {
      if (transaction.goodId == goodId) {
        quantity += transaction.quantity;
      }
    });
    return quantity;
  }

  bool isEmpty() {
    return groups.isEmpty && goods.isEmpty;
  }

  void toggleSearchBar() {
    showSearchBar = !showSearchBar;
    resetSearchText();
  }

  void onSearchChanged(String val) {
    _textSearch = val;
    filter();
    refreshUI();
  }

  void filter() {
    _groups = _allGroups.where((element) => filterGroup(element)).toList();
    _goods = _allGoods.where((element) => filterGood(element)).toList();
  }

  filterGroup(Group group) {
    if (_textSearch.trim().isEmpty) {
      return true;
    }
    switch (_settings.searchGoodsType) {
      case SearchGoodsType.byName:
        {
          return group.name.contains(_textSearch);
        }
      case SearchGoodsType.byDescription:
        {
          return group.description.contains(_textSearch);
        }
      case SearchGoodsType.byBarcode:
        {
          return group.barCode.contains(_textSearch);
        }
      default:
        {
          return group.name.contains(_textSearch) ||
              group.description.contains(_textSearch) ||
              group.barCode.contains(_textSearch);
        }
    }
  }

  filterGood(Good good) {
    if (_textSearch.trim().isEmpty) {
      return true;
    }
    switch (_settings.searchGoodsType) {
      case SearchGoodsType.byName:
        {
          return good.name.contains(_textSearch);
        }
      case SearchGoodsType.byDescription:
        {
          return good.description.contains(_textSearch);
        }
      case SearchGoodsType.byBarcode:
        {
          return good.barCode.contains(_textSearch);
        }
      default:
        {
          return good.name.contains(_textSearch) ||
              good.description.contains(_textSearch) ||
              good.barCode.contains(_textSearch);
        }
    }
  }

  void sort() {
    sortGroups();
    sortGoods();
  }

  void sortGroups() {
    _allGroups.sort((item1, item2) {
      return sortGroupByName(item1, item2);
    });
  }

  int sortGroupByName(Group item1, Group item2) {
    int compare = 0;
    switch (_settings.sortByName) {
      case SortByText.a_to_z:
        {
          compare = item1.name.compareTo(item2.name);
          break;
        }
      case SortByText.a_to_z:
        {
          compare = item2.name.compareTo(item1.name);
          break;
        }
      default:
        {}
    }
    if (compare == 0) {
      return sortGroupByBarCode(item1, item2);
    } else {
      return compare;
    }
  }

  int sortGroupByBarCode(Group item1, Group item2) {
    int compare = 0;
    switch (_settings.sortByBarcode) {
      case SortByNumber.ascending:
        {
          compare = item1.barCode.compareTo(item2.barCode);
          break;
        }
      case SortByNumber.descending:
        {
          compare = item2.barCode.compareTo(item1.barCode);
          break;
        }
      default:
        {}
    }
    /*if (compare == 0){
      return sortGroupByQuantity(item1, item2);
    }else{
      return compare;
    }*/
    return compare;
  }

  /*int sortGroupByQuantity(Group item1, Group item2){
    int compare = 0;
    switch(_settings.sortByQuantity){
      case SortByNumber.ascending:{
        compare =  item1.q.compareTo(item2.name);
        break;
      }
      case SortByNumber.descending:{
        compare =  item2.name.compareTo(item1.name);
        break;
      }
      default: {

      }
    }
    return compare;
  }*/

  void sortGoods() {
    _allGoods.sort((item1, item2) {
      return sortGoodByName(item1, item2);
    });
  }

  int sortGoodByName(Good item1, Good item2) {
    int compare = 0;
    switch (_settings.sortByName) {
      case SortByText.a_to_z:
        {
          compare = item1.name.compareTo(item2.name);
          break;
        }
      case SortByText.a_to_z:
        {
          compare = item2.name.compareTo(item1.name);
          break;
        }
      default:
        {}
    }
    if (compare == 0) {
      return sortGoodByBarCode(item1, item2);
    } else {
      return compare;
    }
  }

  int sortGoodByBarCode(Good item1, Good item2) {
    int compare = 0;
    switch (_settings.sortByBarcode) {
      case SortByNumber.ascending:
        {
          compare = item1.barCode.compareTo(item2.barCode);
          break;
        }
      case SortByNumber.descending:
        {
          compare = item2.barCode.compareTo(item1.barCode);
          break;
        }
      default:
        {}
    }
    if (compare == 0) {
      return sortGoodByQuantity(item1, item2);
    } else {
      return compare;
    }
  }

  int sortGoodByQuantity(Good item1, Good item2) {
    int compare = 0;
    switch (_settings.sortByQuantity) {
      case SortByNumber.ascending:
        {
          compare = (item1.quantity - item2.quantity);
          break;
        }
      case SortByNumber.descending:
        {
          compare = (item2.quantity - item1.quantity);
          break;
        }
      default:
        {}
    }
    return compare;
  }

  void setSearchGoodsType(SearchGoodsType type) {
    _settings.searchGoodsType = type;
    presenter.setSettings(_settings);

    resetSearchText();
  }

  void resetSearchText() {
    searchTextController.text = "";
    onSearchChanged("");
  }

  String getSearchTextHint() {
    switch (_settings.searchGoodsType) {
      case SearchGoodsType.byName:
        return AppLocalizations.of(getContext()).search_type_by_name;
      case SearchGoodsType.byDescription:
        return AppLocalizations.of(getContext()).search_type_by_description;
      case SearchGoodsType.byBarcode:
        return AppLocalizations.of(getContext()).search_type_by_barcode;
      default:
        return AppLocalizations.of(getContext()).search_type_everywhere;
    }
  }

  bool hasSortOptions() {
    if (_settings == null) {
      return false;
    }
    if (_settings.sortByName != SortByText.no_sort ||
        _settings.sortByBarcode != SortByNumber.no_sort ||
        _settings.sortByQuantity != SortByNumber.no_sort) {
      return true;
    }
    return false;
  }
}
