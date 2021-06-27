import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/sort_item_dialog.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

import 'base_list_presenter.dart';

abstract class BaseListController<M extends BaseModel, S extends BaseSettings,
    P extends BaseListPresenter> extends Controller {
  bool filterItem(M item, String textSearch);

  bool isLoading = false;
  TextEditingController searchTextController;
  List<M> _allItems = [];
  List<M> _items = [];
  S _settings;
  P _presenter;
  bool showSearchBar = false;
  String _textSearch = "";

  List<M> get allItems => _allItems;

  List<M> get items => _items;

  String get textSearch => _textSearch;

  P get presenter => _presenter;

  String getSaveItemRouteName();

  M getEmptyItem();

  BaseListController(this._presenter) : super() {
    isLoading = true;
    searchTextController = TextEditingController();
    _presenter.getSettings();
  }

  @override
  void initListeners() {
    _presenter.getSettingsOnNext = (settings) {
      _settings = settings;
      _presenter.getItems();
    };
    _presenter.getSettingsOnError = (e) {
      showErrorToast(e.toString());
    };
    _presenter.setSettingsOnComplete = () {
      refreshItems();
    };
    _presenter.setSettingsOnError = (e) {
      showErrorToast(e.toString());
    };

    _presenter.getItemsOnNext = (items) {
      isLoading = false;
      _allItems = items;
      refreshItems();
    };
    _presenter.getItemsOnError = (e) {
      isLoading = false;

      showErrorToast(e.message.toString());
      refreshUI();
    };
    //delete
    presenter.deleteItemOnComplete = () {
      int index =
          allItems.indexWhere((element) => element.id == presenter.deletedId);
      allItems.removeAt(index);
      refreshItems();
    };
    presenter.deleteItemOnError = (e) {
      showErrorToast(e.toString());
    };
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
    _items =
        _allItems.where((element) => filterItem(element, _textSearch)).toList();
  }

  void resetSearchText() {
    searchTextController.text = "";
    onSearchChanged("");
  }

  bool hasSortOptions() {
    if (_settings == null) {
      return false;
    }
    return (_settings.sortByName != SortByText.no_sort);
  }

  void sort() {
    switch (_settings.sortByName) {
      case SortByText.a_to_z:
        {
          _allItems.sort((item1, item2) {
            return item1.name.compareTo(item2.name);
          });
          break;
        }
      case SortByText.z_to_a:
        {
          _allItems.sort((item1, item2) {
            return item2.name.compareTo(item1.name);
          });
          break;
        }
      default:
        {}
    }
  }

  void onShowSortDialog() {
    showDialog(
        context: getContext(),
        builder: (_) => SortItemDialog(_settings, () {
              _presenter.setSettings(_settings);
            }),
        barrierDismissible: true);
  }

  void refreshItems() {
    sort();
    filter();
    refreshUI();
  }

  void onAddItem() async {
    final result = await Navigator.of(getContext())
        .pushNamed(getSaveItemRouteName(), arguments: {"item": getEmptyItem()});
    if (result != null) {
      allItems.add(result);
      refreshItems();
    }
  }

  void onItemPressed(M item) async {
    final result = await Navigator.of(getContext())
        .pushNamed(getSaveItemRouteName(), arguments: {'item': item});
    if (result != null) {
      int index = allItems.indexWhere((element) => element.id == item.id);
      allItems[index] = result;
      refreshItems();
    }
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
