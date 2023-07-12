import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/good.dart';
import '../../../../domain/entities/goods_settings.dart';
import '../../../../domain/entities/group.dart';
import '../../../../domain/entities/search_goods_type.dart';
import '../../base/base_cubit.dart';
import '../../base/base_state.dart';
import 'goods_data.dart';

@injectable
class GoodsCubit extends BaseCubit<GoodsData> {
  GoodsCubit() : super(
      GoodsData(
          state: InitialState(),
          isSelection: false,
          goods: [],
          groups: [],
          hasSortOptions: false,
          searchText: "",
          settings: GoodsSettings(),
          showSearchBar: false
      ));

  @override
  void dispose() {
    // TODO: implement dispose
  }
  Future<void> initState() async {
    //final settings = await secureStorage.
    //emit(state.copy)
    //emit(state.copyWith());
  }
  void onSelectedGroupTapped(int index) {
    /*if (index == -1) {
      selectedGroups.clear();
    } else {
      selectedGroups = selectedGroups.sublist(0, index + 1);
    }
    loadData();
    refreshUI();*/
  }
  void onGroupTapped(Group group) {
    /*selectedGroups.add(group);
    loadData();
    refreshUI();*/
  }

  void onGroupLongPressed(Group group) {
    /*showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  openSelectGroupForGroup(group);
                },
                child: Text(
                    AppLocalizations.of(getContext())?.action_move_to_group??''),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  onEditGroup(group);
                },
                child:
                Text(AppLocalizations.of(getContext()).action_edit_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  showInfoToast("under development");
                },
                child:
                Text(AppLocalizations.of(getContext()).action_delete_group),
              ),
            ],
          );
        },
        barrierDismissible: true);*/
  }
  void onGoodTapped(Good good) async {
    /*if (this._isSelection) {
      showAddQuantityDialog(good);
    } else {
      final result = await Navigator.of(getContext())
          .pushNamed(Pages.save_good, arguments: {"item": good, "enableAddTransactions": true});
      if (result != null) {
        loadData();
      }
    }*/
  }
  void onGoodLongPressed(Good good) {
    /*showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  openSelectGroupForGood(good);
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
        barrierDismissible: true);*/
  }
  void onAddGood() async {
    /*Good item = Good();
    item.directory = getDirectory();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();

    final result = await Navigator.of(getContext())
        .pushNamed(Pages.save_good, arguments: {"item": item, "enableAddTransactions": true});
    if (result != null) {
      if (_isSelection) {
        showAddQuantityDialog(result);
      } else {
        loadData();
      }
    }*/
  }

  void onAddGroup() async {
    /*Group item = Group();
    item.directory = getDirectory();
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();

    final result = await Navigator.of(getContext())
        .pushNamed(Pages.save_group, arguments: {"item": item});
    if (result != null) {
      loadData();
    }*/
  }
  void toggleSearchBar() {
    /*showSearchBar = !showSearchBar;
    resetSearchText();*/
  }
  void onShowSortDialog() async {
    /*showDialog(
        context: getContext(),
        builder: (_) => SortGoodsDialog(_settings, () {
          presenter.setSettings(_settings);
          refreshItems();
        }),
        barrierDismissible: true);*/
  }
  void openHelpPage() async {
    /*String code = await appDataManager.sharedPrefsHelper.getLanguageCode();
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(getContext()).goods_title,
      "content": HelpUtils.getMarkdownData(code, HelpType.GOODS)
    });*/
  }
  String getSearchTextHint(BuildContext context) {
    //return _settings.searchGoodsType.getText(context);
    return "";
  }
  onSearchBarCode() async {
    /*try {
      var barcodeResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          AppLocalizations.of(getContext()).action_cancel,
          true,
          ScanMode.BARCODE);
      if (barcodeResult != "-1") {
        searchTextController.text = barcodeResult;
        justScanCode = true;
        onSearchChanged(barcodeResult);
        justScanCode = false;
      }
    } on PlatformException {
      showErrorToast('Failed to get platform version.');
    }*/
  }
  void setSearchGoodsType(SearchGoodsType type) {
    /*_settings.searchGoodsType = type;
    presenter.setSettings(_settings);

    resetSearchText();*/
  }
  void resetSearchText() {
    /*searchTextController.text = "";
    onSearchChanged("");*/
  }
  void onSearchTextChanged(String newValue) {
    //_textSearch = val;
    //filter();
    //refreshUI();

    //final trimValue = newValue.trim();
    //emit(state.copyWith(textSearch))
    //if (trimValue.isEmpty) {
      //emit(state.copyWith(state: ShowPagingVisitsState(), searchText: newValue));
    //} else {
      //List<Visit> filteredVisits = getFilteredVisits(trimValue);
      //emit(state.copyWith(state: ShowFilteredVisitsState(), searchText: newValue, filteredVisits: filteredVisits));
    //}
  }
  void onBackPressed() {
    //Navigator.of(getContext()).pop(transactions);
  }

}