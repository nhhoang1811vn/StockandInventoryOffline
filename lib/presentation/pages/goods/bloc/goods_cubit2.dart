import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/pages/goods/sort/sort_by_barcode_goods.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/good.dart';
import '../../../../domain/entities/goods_setting.dart';
import '../../../../domain/entities/group.dart';
import '../../../../domain/entities/search_goods_type.dart';
import '../../../../domain/entities/sort_by_text.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../../../../domain/usecases/groups/groups_usecases.dart';
import '../../base/base_sort_items.dart';
import '../../base/base_state.dart';
import '../sort/sort_by_barcode_groups.dart';
import '../sort/sort_by_quantity_goods.dart';

part 'goods_cubit2.freezed.dart';
part 'goods_state.dart';

@injectable
class GoodsCubit extends Cubit<GoodsState> {
  final Storage storage;
  final GoodsUseCases goodsUseCase;
  final GroupsUseCases groupsUseCase;
  final DocumentUseCases documentsUseCases;
  GoodsCubit({
    required this.storage,
    required this.goodsUseCase,
    required this.groupsUseCase,
    required this.documentsUseCases

  }) : super(GoodsState.initial(state: InitialState(), settings: storage.getGoodsSetting()));
  void initState(bool isSelection, int? documentId, DocumentType? documentType) async {
    emit(state.copyWith(isSelection: isSelection, showSearchBar: isSelection, documentId: documentId, documentType: documentType));
    loadItems();
  }
  void onSelectedGroupTapped(int index) {
    if (index == -1) {
      emit(state.copyWith(selectedGroups: []));
    } else {
      List<Group> items = state.selectedGroups.sublist(0, index + 1);
      emit(state.copyWith(selectedGroups: items));
    }
    loadItems();
  }
  void onGroupTapped(Group group) {
    List<Group> items = [];
    items.addAll(state.selectedGroups);
    items.add(group);
    emit(state.copyWith(selectedGroups: items));
    loadItems();
  }
  void onAddGood(){
    Good item = Good();
    item.directory = getDirectory();
    item.storeId = storage.getSelectedStoreId();

    emit(state.copyWith(state: SaveGoodState(item)));
  }
  String getDirectory(){
    String result = "";
    state.selectedGroups.forEach((element) {
      result += "/" + element.id.toString();
    });
    if (result.isEmpty){
      result = "/";
    }
    return result;
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
    Group item = Group();
    item.directory = getDirectory();
    item.storeId = storage.getSelectedStoreId();

    emit(state.copyWith(state: AddGroupState(item)));
  }
  void onShowSearchBarMenuClicked(){
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
    resetSearchText();
  }
  void onSortMenuClicked(){
    emit(state.copyWith(state: OpenSortDialogListState()));
  }
  void onHelpMenuClicked() async {
    emit(state.copyWith(state: OpenHelpPageState()));
  }
  String getSearchTextHint(BuildContext context) {
    return state.settings.searchGoodsType.getText(context);
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
    GoodsSetting settings = state.settings.copyWith(searchGoodsType: type);
    emit(state.copyWith(settings: settings));
    storage.setGoodsSetting(settings);
    filter();
  }
  void resetSearchText() {
    emit(state.copyWith(textSearch: ""));
    filter();
    sort();
  }
  void onSearchTextChanged(String newValue) {
    emit(state.copyWith(textSearch: newValue));
    filter();
    sort();
  }
  void onBackPressed() {
    //Navigator.of(getContext()).pop(transactions);
  }
  bool hasSortOptions() {
    return (state.settings.sortByName != SortByText.no_sort
          || state.settings.sortByBarcode != SortByNumber.no_sort
        ||state.settings.sortByQuantity != SortByNumber.no_sort);
  }

  void setSettings(GoodsSetting settings) {
    storage.setGoodsSetting(settings);
    emit(state.copyWith(settings: settings));
    sort();
  }

  void loadItems() async{
    String directory = getDirectory();
    List<Group> allGroups = await groupsUseCase.getGroupsByDirectory(directory);
    List<Good> allGoods = await goodsUseCase.getGoodsByDirectory(directory);
    emit(state.copyWith(allGroups: allGroups, allGoods: allGoods));
    filter();
    sort();
  }
  void filter(){
    List<Group> groups = filterGroups();
    List<Good> goods = filterGoods();
    emit(state.copyWith(groups: groups, goods: goods));
  }
  void sort(){
    List<Group> groups = sortGroups();
    List<Good> goods = sortGoods();
    emit(state.copyWith(groups: groups, goods: goods));
  }
  List<Group> sortGroups(){
    List<SortItems<Group>> options = [];
    switch (state.settings.sortByName) {
      case SortByText.a_to_z:
        {
          options.add(SortByNameAToZ());
          break;
        }
      case SortByText.z_to_a:
        {
          options.add(SortByNameZToA());
          break;
        }
      default:
        {}
    }
    switch (state.settings.sortByBarcode) {
      case SortByNumber.ascending:
        {
          options.add(SortByBarCodeAscendingGroup());
          break;
        }
      case SortByNumber.descending:
        {
          options.add(SortByBarCodeDescendingGroup());
          break;
        }
      default:
        {}
    }
    if (options.isEmpty) {
      options.add(SortByCreatedDate());
    }
    List<Group> items = [];
    items.addAll(state.groups);
    items.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    return items;
  }
  List<Good> sortGoods(){
    List<SortItems<Good>> options = [];
    switch (state.settings.sortByName) {
      case SortByText.a_to_z:
        {
          options.add(SortByNameAToZ());
          break;
        }
      case SortByText.z_to_a:
        {
          options.add(SortByNameZToA());
          break;
        }
      default:
        {}
    }
    switch (state.settings.sortByBarcode) {
      case SortByNumber.ascending:
        {
          options.add(SortByBarCodeAscendingGood());
          break;
        }
      case SortByNumber.descending:
        {
          options.add(SortByBarCodeDescendingGood());
          break;
        }
      default:
        {}
    }
    switch (state.settings.sortByQuantity) {
      case SortByNumber.ascending:
        {
          options.add(SortByQuantityAscendingGood());
          break;
        }
      case SortByNumber.descending:
        {
          options.add(SortByQuantityDescendingGood());
          break;
        }
      default:
        {}
    }
    if (options.isEmpty) {
      options.add(SortByCreatedDate());
    }
    List<Good> items = [];
    items.addAll(state.goods);
    items.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    return items;
  }
  deleteGood(int id) async{
    await goodsUseCase.delete(id);
    loadItems();
  }
  /*Future<bool> deleteGroup(int id) async{
    return await groupsUseCase.delete(id);
  }*/
  List<Group> filterGroups(){
    List<Group> results = state.allGroups.where((element) => filterGroup(element)).toList();
    return results;
  }
  bool filterGroup(Group group) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    switch (state.settings.searchGoodsType) {
      case SearchGoodsType.byName:
        {
          return group.name.contains(state.textSearch);
        }
      case SearchGoodsType.byDescription:
        {
          return group.description.contains(state.textSearch);
        }
      case SearchGoodsType.byBarcode:
        {
          return group.barCode.contains(state.textSearch);
        }
      default:
        {
          return group.name.contains(state.textSearch) ||
              group.description.contains(state.textSearch) ||
              group.barCode.contains(state.textSearch);
        }
    }
  }
  List<Good> filterGoods(){
    List<Good> results = state.allGoods.where((element) => filterGood(element)).toList();
    return results;
  }
  bool filterGood(Good item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    switch (state.settings.searchGoodsType) {
      case SearchGoodsType.byName:
        {
          return item.name.contains(state.textSearch);
        }
      case SearchGoodsType.byDescription:
        {
          return item.description.contains(state.textSearch);
        }
      case SearchGoodsType.byBarcode:
        {
          return item.barCode.contains(state.textSearch);
        }
      default:
        {
          return item.name.contains(state.textSearch) ||
              item.description.contains(state.textSearch) ||
              item.barCode.contains(state.textSearch);
        }
    }
  }

  void moveGoodToGroup(Good item, Group group) {
    if (group.id == -1){
      item.directory = "/";
    } else if (group.directory == "/"){
      item.directory = "/" + group.id.toString();
    }else{
      item.directory = group.directory + "/" + group.id.toString();
    }
    goodsUseCase.update(item);
    loadItems();
  }

  void addTransaction(Good good, int quantity) async {
    DocumentTransaction transaction = DocumentTransaction();
    transaction.documentId = state.documentId!;
    transaction.goodId = good.id;
    transaction.quantity = quantity;
    transaction.type = state.documentType!;
    transaction.storeId = storage.getSelectedStoreId();
    int id = await documentsUseCases.insertTransaction(transaction);
    if (id > 0){
      emit(state.copyWith(state: InsertTransactionSuccessState()));
    }else{
      emit(state.copyWith(state: InsertTransactionFailedState()));
    }
  }
}