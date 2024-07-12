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

part 'goods_cubit.freezed.dart';
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
  void initState(bool isSelection, Document? document) async {
    emit(state.copyWith(isSelection: isSelection, showSearchBar: isSelection, document: document));
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
    item.groupId = getSelectedGroupId();
    item.storeId = storage.getSelectedStoreId();

    emit(state.copyWith(state: OpenSaveGoodPageState(item)));
  }
  int? getSelectedGroupId(){
    if (state.selectedGroups.isEmpty){
      return null;
    }
    return state.selectedGroups.last.id;
  }
  void onAddGroup() async {
    Group item = Group();
    item.groupId = getSelectedGroupId();
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
  void onSearchBarcodeClicked(){
    emit(state.copyWith(state: OpenBarcodeScannerToSearchState()));
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
  }
  void onSearchTextChanged(String newValue) {
    emit(state.copyWith(textSearch: newValue));
    filter();
    //sort();
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
    filter();
  }

  void loadItems() async{
    int? groupId = getSelectedGroupId();
    List<Group> allGroups = await groupsUseCase.getGroupsByGroupId(groupId);
    List<Good> allGoods = await goodsUseCase.getGoodsByGroupId(groupId);
    emit(state.copyWith(allGroups: allGroups, allGoods: allGoods));
    sort();
    filter();
  }
  void filter(){
    List<Group> groups = filterGroups();
    List<Good> goods = filterGoods();

    double quantityTotal = 0;
    double purchasePriceTotal = 0.0;
    double salePriceTotal = 0.0;
    goods.forEach((element) {
      quantityTotal += element.quantity;
      purchasePriceTotal += (element.quantity * (element.purchasePrice ?? 0.0));
      salePriceTotal += (element.quantity * (element.salePrice?? 0.0));
    });
    emit(state.copyWith(groups: groups, goods: goods,quantityTotal: quantityTotal,purchasePriceTotal: purchasePriceTotal,salePriceTotal: salePriceTotal));
  }
  void sort(){
    List<Group> groups = sortGroups();
    List<Good> goods = sortGoods();
    emit(state.copyWith(allGroups: groups, allGoods: goods));
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
    items.addAll(state.allGroups);
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
    items.addAll(state.allGoods);
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
  deleteGroup(int id) async {
    await groupsUseCase.delete(id);
    loadItems();
  }
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
          return (group.barCode != null && group.barCode!.contains(state.textSearch));
        }
      default:
        {
          return group.name.contains(state.textSearch) ||
              group.description.contains(state.textSearch) ||
              (group.barCode != null && group.barCode!.contains(state.textSearch));
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
          return (item.barCode != null && item.barCode!.contains(state.textSearch));
        }
      default:
        {
          return item.name.contains(state.textSearch) ||
              item.description.contains(state.textSearch) ||
              (item.barCode != null && item.barCode!.contains(state.textSearch));
        }
    }
  }

  void moveGoodToGroup(Good item, int? groupId) {
    item.groupId = groupId;
    goodsUseCase.update(item);
    loadItems();
  }
  void moveGroupToGroup(Group item, int? groupId){
    item.groupId = groupId;
    groupsUseCase.update(item);
    loadItems();
  }
  void addTransaction(int goodId, double quantity, double price) async{
      DocumentTransaction transaction = DocumentTransaction();
      transaction.documentId = state.document!.id!;
      transaction.goodId = goodId;
      transaction.quantity = quantity;
      transaction.price = price;
      transaction.type = state.document!.type;
      transaction.storeId = storage.getSelectedStoreId();
      int transactionId = await documentsUseCases.insertTransaction(transaction);
      if (transactionId > 0){
        if (transaction.type == DocumentType.incoming){
          emit(state.copyWith(state: InsertTransactionSuccessState(goodId, quantity)));
        }else{
          emit(state.copyWith(state: InsertTransactionSuccessState(goodId, -quantity)));
        }
      }else{
        emit(state.copyWith(state: InsertTransactionFailedState()));
      }
  }

  void updateQuantity(int goodId, double quantity) {
    List<Good> goods = [];
    goods.addAll(state.allGoods);
    for (Good item in goods){
      if (item.id == goodId){
        item.quantity += quantity;
        break;
      }
    }
    emit(state.copyWith(allGoods: goods));
    filter();
  }
}