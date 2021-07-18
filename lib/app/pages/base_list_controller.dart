import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/sort_item_dialog.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';

import 'base/base_sort_items.dart';
import 'base_list_presenter.dart';
import 'help_content.dart';

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

  String getTitle();
  HelpType getHelpType();

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

      showErrorToast(e.toString());
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
    List<SortItems<M>> sortOptions = [];
    switch (_settings.sortByName) {
      case SortByText.a_to_z:
        {
          sortOptions.add(SortByNameAToZ());
          break;
        }
      case SortByText.z_to_a:
        {
          sortOptions.add(SortByNameZToA());
          break;
        }
      default:
        {}
    }
    if (sortOptions.isEmpty) {
      sortOptions.add(SortByCreatedDate());
    }
    _allItems.sort((item1, item2) {
      int compare = 0;
      for (final option in sortOptions) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
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
  void onOpenHelpPage() async{
    String languageCode = await appDataManager.sharedPrefsHelper.getLanguageCode();
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": getTitle(),
      "content": HelpUtils.getMarkdownData(languageCode, getHelpType())
    });
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
