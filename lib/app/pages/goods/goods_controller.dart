import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base/base_sort_items.dart';
import 'package:good_manager/app/pages/goods/add_quantity_good_dialog.dart';
import 'package:good_manager/app/pages/goods/goods_presenter.dart';
import 'package:good_manager/app/pages/goods/sort/sort_by_barcode_goods.dart';
import 'package:good_manager/app/pages/goods/sort/sort_by_barcode_groups.dart';
import 'package:good_manager/app/pages/goods/sort/sort_by_quantity_goods.dart';
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
import 'package:sprintf/sprintf.dart';

import '../pages.dart';

class GoodsController extends Controller {
  TextEditingController searchTextController;
  GoodsPresenter presenter;
  List<Group> selectedGroups = [];
  bool isLoading = false;

  bool groupsRetrieved;
  bool goodsRetrieved;

  bool _isSelection;
  List<Group> _allGroups = [];
  List<Good> _allGoods = [];

  List<Group> _groups = [];
  List<Good> _goods = [];

  List<Group> get groups => _groups;

  List<Good> get goods => _goods;

  bool get isSelection => _isSelection;
  DocumentType _documentType;
  List<DocumentTransaction> transactions = [];

  bool showSearchBar = false;
  String _textSearch = "";

  String get textSearch => _textSearch;

  DocumentType get documentType => _documentType;

  GoodsSettings _settings;

  GoodsController(storeRepository, goodRepository, transactionRepository,
      this._isSelection, this._documentType, this.transactions)
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
    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    int groupId = getSelectedGroupId();
    presenter.getGroups(groupId);
  }

  void retrieveGoods() async {
    //int storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    int groupId = getSelectedGroupId();
    presenter.getGoods(groupId);
  }

  void refreshItems() {
    sort();
    filter();
    if (transactions != null) {
      this._goods.forEach((element) {
        element.pendingQuantity = getPendingQuantity(element.id);
      });
    }
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

    presenter.deleteGoodOnComplete = () {
      loadData();
    };
    presenter.deleteGoodOnError = (e) {
      showErrorToast(e.toString());
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
    String title = "";
    if (_documentType == DocumentType.incoming) {
      title = AppLocalizations.of(getContext()).add_quantity_dialog_title;
    } else {
      title = AppLocalizations.of(getContext()).subtract_quantity_dialog_title;
    }
    showDialog(
        context: getContext(),
        builder: (_) =>
            AddQuantityGoodDialog(title, (it) => {onQuantityAdded(good, it)}),
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
    transaction.currentQuantity = 0;
    transaction.quantity = quantity;
    transaction.type = _documentType;

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
                  showDeleteGoodConfirm(good);
                },
                child: Text(AppLocalizations.of(getContext()).action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }

  void showDeleteGoodConfirm(Good good) {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(getContext()).message_confirm_delete_good,
                [good.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: Text(AppLocalizations.of(getContext()).action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(getContext());
                  presenter.deleteGood(good.id);
                },
                child: Text(AppLocalizations.of(getContext()).action_ok),
              )
            ],
          );
        });
  }

  int getPendingQuantity(int goodId) {
    int quantity = 0;
    transactions.forEach((transaction) {
      if (transaction.goodId == goodId) {
        quantity += (transaction.quantity - transaction.currentQuantity);
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
    List<SortItems<Group>> groupSortOptions = [];
    List<SortItems<Good>> goodSortOptions = [];
    switch (_settings.sortByName) {
      case SortByText.a_to_z:
        {
          groupSortOptions.add(SortByNameAToZ());
          goodSortOptions.add(SortByNameAToZ());
          break;
        }
      case SortByText.z_to_a:
        {
          groupSortOptions.add(SortByNameZToA());
          goodSortOptions.add(SortByNameZToA());
          break;
        }
      default:
        {}
    }
    switch (_settings.sortByBarcode) {
      case SortByNumber.ascending:
        {
          groupSortOptions.add(SortByBarCodeAscendingGroup());
          goodSortOptions.add(SortByBarCodeAscendingGood());
          break;
        }
      case SortByNumber.descending:
        {
          groupSortOptions.add(SortByBarCodeDescendingGroup());
          goodSortOptions.add(SortByBarCodeDescendingGood());
          break;
        }
      default:
        {}
    }
    switch (_settings.sortByQuantity) {
      case SortByNumber.ascending:
        {
          goodSortOptions.add(SortByQuantityAscendingGood());
          break;
        }
      case SortByNumber.descending:
        {
          goodSortOptions.add(SortByQuantityDescendingGood());
          break;
        }
      default:
        {}
    }
    if (groupSortOptions.isEmpty) {
      groupSortOptions.add(SortByCreatedDate());
    }
    if (goodSortOptions.isEmpty) {
      goodSortOptions.add(SortByCreatedDate());
    }
    _allGroups.sort((item1, item2) {
      int compare = 0;
      for (final option in groupSortOptions) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    _allGoods.sort((item1, item2) {
      int compare = 0;
      for (final option in goodSortOptions) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
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
        return AppLocalizations.of(getContext()).search_goods_type_by_name;
      case SearchGoodsType.byDescription:
        return AppLocalizations.of(getContext())
            .search_goods_type_by_description;
      case SearchGoodsType.byBarcode:
        return AppLocalizations.of(getContext()).search_goods_type_by_barcode;
      default:
        return AppLocalizations.of(getContext()).search_goods_type_everywhere;
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

  Future<bool> onBackPressed() {
    Navigator.of(getContext()).pop(transactions);
  }
}
