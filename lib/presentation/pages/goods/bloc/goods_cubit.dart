import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';
import 'package:good_manager/presentation/criteria/filter_good_by_everywhere_criteria.dart';
import 'package:good_manager/presentation/criteria/group_by_everywhere_criteria.dart';
import 'package:good_manager/presentation/pages/goods/sort/sort_by_barcode_goods.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/exception/duplicate_exceptions.dart';
import '../../../../domain/exception/insufficient_stock_exception.dart';
import '../../base/base_sort_items.dart';
import '../../base/base_state.dart';
import '../component/excel_column_mapping.dart';
import '../good_copy.dart';
import '../goods_excel_export.dart';
import '../goods_excel_import.dart';
import '../group_copy.dart';
import '../sort/sort_by_barcode_groups.dart';
import '../sort/sort_by_quantity_goods.dart';

part 'goods_cubit.freezed.dart';
part 'goods_state.dart';

@injectable
class GoodsCubit extends Cubit<GoodsState> {
  //final Storage storage;
  final GoodsUseCases goodsUseCase;
  final GroupsUseCases groupsUseCase;
  final DocumentUseCases documentsUseCases;
  final StoresUseCase storesUseCase;

  GoodsCubit({
    required this.goodsUseCase,
    required this.groupsUseCase,
    required this.documentsUseCases,
    required this.storesUseCase,
  }) : super(
          GoodsState.initial(
            state: InitialState(),
            settings: AppSettings.getGoodsSetting(),
            properties: AppSettings.getGoodPropertiesSettings(),
          ),
        ) {
    AppSettings.goodPropertiesRevision.addListener(_onPropertiesChanged);
  }

  bool _watchesStock = false;

  @override
  Future<void> close() {
    AppSettings.goodPropertiesRevision.removeListener(_onPropertiesChanged);
    DocumentUseCases.stockRevision.removeListener(_onStockChanged);
    return super.close();
  }

  /// The Inventory tab stays alive behind the other tabs, so it reloads its
  /// goods when a Document change moves stock. The Select Good screen updates
  /// its own quantities and does not watch.
  void _onStockChanged() {
    if (isClosed) return;
    loadData();
  }

  void _onPropertiesChanged() {
    if (isClosed) return;
    emit(state.copyWith(properties: AppSettings.getGoodPropertiesSettings()));
    refresh();
  }

  /// Barcode sorting is ignored while the Barcode property is hidden; the
  /// saved sort setting itself is left untouched.
  SortByNumber get _effectiveSortByBarcode => state.properties.showBarcode
      ? state.settings.sortByBarcode
      : SortByNumber.no_sort;

  void initState(bool isSelection, Document? document) async {
    if (!isSelection && !_watchesStock) {
      _watchesStock = true;
      DocumentUseCases.stockRevision.addListener(_onStockChanged);
    }
    var minQuantitySettings = await AppSettings.getMinimumQuantitySettings();
    if (isClosed) return;

    emit(
      state.copyWith(
        properties: AppSettings.getGoodPropertiesSettings(),
        isSelection: isSelection,
        showSearchBar: isSelection,
        document: document,
        showMinQuantity: minQuantitySettings.showInList,
        minQuantityColor: Color(minQuantitySettings.color),
      ),
    );
    loadData();
  }

  void onSelectedGroupTapped(int index) {
    if (index == -1) {
      emit(state.copyWith(selectedGroups: []));
    } else {
      List<Group> items = state.selectedGroups.sublist(0, index + 1);
      emit(state.copyWith(selectedGroups: items));
    }
    loadItemsInSelectedGroup();
  }

  void onGroupTapped(Group group) async {
    var items = await getSelectedGroupValue(group);
    if (isClosed) return;
    emit(
      state.copyWith(
        selectedGroups: items,
        showSearchBar: false,
        textSearch: "",
      ),
    );
    loadItemsInSelectedGroup();
  }

  Future<List<Group>> getSelectedGroupValue(Group group) async {
    List<Group> results = [];
    Group item = group;
    results.add(item);
    while (item.groupId != null) {
      item = await groupsUseCase.getById(item.groupId!);
      results.add(item);
    }
    return List.from(results.reversed);
  }

  void onAddGood() {
    Good item = Good();
    item.groupId = getSelectedGroupId();
    item.storeId = AppSettings.getSelectedStoreId();

    emit(state.copyWith(state: OpenSaveGoodPageState(item)));
  }

  Future<List<Store>> getStores() {
    return storesUseCase.getAll();
  }

  Future<String?> getGroupName(int? groupId) async {
    if (groupId == null) return null;
    final group = await groupsUseCase.getById(groupId);
    return group.name;
  }

  void onCopyGood(Good source, int storeId, int? groupId) {
    final copy = buildCopyOfGood(source, storeId: storeId, groupId: groupId);
    emit(state.copyWith(state: OpenSaveGoodPageState(copy)));
  }

  void onCopyGroup(Group source, int storeId, int? parentGroupId) {
    final copy =
        buildCopyOfGroup(source, storeId: storeId, groupId: parentGroupId);
    emit(state.copyWith(state: AddGroupState(copy)));
  }

  int? getSelectedGroupId() {
    if (state.selectedGroups.isEmpty) {
      return null;
    }
    return state.selectedGroups.last.id;
  }

  void onAddGroup() async {
    Group item = Group();
    item.groupId = getSelectedGroupId();
    item.storeId = AppSettings.getSelectedStoreId();

    emit(state.copyWith(state: AddGroupState(item)));
  }

  void onShowSearchBarMenuClicked() {
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
    onSearchTextChanged("");
  }

  void onHelpMenuClicked() async {
    emit(state.copyWith(state: OpenHelpPageState()));
  }

  void onListSettingsMenuClicked() {
    emit(state.copyWith(state: OpenListSettingsDialogState()));
  }

  void onSearchTextChanged(String newValue) {
    emit(state.copyWith(textSearch: newValue));
    refresh();
  }

  void setSettings(GoodsSetting settings) {
    AppSettings.setGoodsSetting(settings);
    emit(state.copyWith(settings: settings));
    refresh();
  }

  void loadData() async {
    int storeId = AppSettings.getSelectedStoreId();
    List<Group> allGroups = await groupsUseCase.getAllByStoreId(storeId);
    List<Good> allGoods = await goodsUseCase.getAllByStoreId(storeId);
    if (isClosed) return;
    emit(state.copyWith(allGroups: allGroups, allGoods: allGoods));
    refresh();
  }

  void refresh() {
    if (isClosed) return;
    if (state.textSearch.isNotEmpty) {
      //show item match search text
      loadItemsMatchSearchText();
    } else {
      //show item in selected group
      loadItemsInSelectedGroup();
    }
  }

  Criteria<Group> getFilterGroupCriteria() {
    return GroupByEverywhereCriteria(state.textSearch);
    // switch(state.settings.searchGoodsType){
    //   case SearchGoodsType.byName:
    //     return GroupByNameCriteria(state.textSearch);
    //   case SearchGoodsType.byDescription:
    //     return GroupByDescriptionCriteria(state.textSearch);
    //   case SearchGoodsType.byBarcode:
    //     return GroupByBarcodeCriteria(state.textSearch);
    //   default:
    //     return GroupByEverywhereCriteria(state.textSearch);
    // }
  }

  Criteria<Good> getFilterGoodCriteria() {
    return FilterGoodByEverywhereCriteria(state.textSearch);
    // switch(state.settings.searchGoodsType){
    //   case SearchGoodsType.byName:
    //     return FilterGoodByNameCriteria(state.textSearch);
    //   case SearchGoodsType.byDescription:
    //     return FilterGoodByDescriptionCriteria(state.textSearch);
    //   case SearchGoodsType.byBarcode:
    //     return FilterGoodByBarcodeCriteria(state.textSearch);
    //   default:

    // }
  }

  void loadItemsMatchSearchText() {
    if (isClosed) return;
    Criteria<Group> groupCriteria = getFilterGroupCriteria();
    List<Group> groups = groupCriteria.meetCriteria(state.allGroups);

    Criteria<Good> goodCriteria = getFilterGoodCriteria();
    List<Good> goods = goodCriteria.meetCriteria(state.allGoods);

    //hide zero entries
    if (!state.isSelection && state.settings.hideZeroEntries) {
      goods = goods.where((item) => item.quantity > 0).toList();
    }

    List<SortItems<Group>> groupSortOptions = getGroupSortOptions();
    groups = getGroupWithSortOption(groups, groupSortOptions);

    List<SortItems<Good>> goodSortOptions = getGoodSortOptions();
    goods = getGoodWithSortOption(goods, goodSortOptions);

    emit(state.copyWith(groups: groups, goods: goods));
    updateTotalInfo();
  }

  void loadItemsInSelectedGroup() {
    if (isClosed) return;
    int? groupId = getSelectedGroupId();
    List<Group> groups =
        state.allGroups.where((item) => item.groupId == groupId).toList();
    List<Good> goods =
        state.allGoods.where((item) => item.groupId == groupId).toList();

    //hide zero entries
    if (!state.isSelection && state.settings.hideZeroEntries) {
      goods = goods.where((item) => item.quantity > 0).toList();
    }

    List<SortItems<Group>> groupSortOptions = getGroupSortOptions();
    groups = getGroupWithSortOption(groups, groupSortOptions);

    List<SortItems<Good>> goodSortOptions = getGoodSortOptions();
    goods = getGoodWithSortOption(goods, goodSortOptions);

    emit(state.copyWith(groups: groups, goods: goods));
    updateTotalInfo();
  }

  void updateTotalInfo() {
    if (isClosed) return;
    double quantityTotal = 0;
    double purchasePriceTotal = 0.0;
    double salePriceTotal = 0.0;
    state.goods.forEach((element) {
      quantityTotal += element.quantity;
      purchasePriceTotal += (element.quantity * (element.purchasePrice ?? 0.0));
      salePriceTotal += (element.quantity * (element.salePrice ?? 0.0));
    });
    emit(
      state.copyWith(
        quantityTotal: quantityTotal,
        purchasePriceTotal: purchasePriceTotal,
        salePriceTotal: salePriceTotal,
      ),
    );
  }

  List<Group> getGroupWithSortOption(
    List<Group> items,
    List<SortItems> options,
  ) {
    List<Group> results = [];
    results.addAll(items);
    results.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    return results;
  }

  List<Good> getGoodWithSortOption(List<Good> items, List<SortItems> options) {
    List<Good> results = [];
    results.addAll(items);
    results.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    return results;
  }

  List<SortItems<Group>> getGroupSortOptions() {
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
    switch (_effectiveSortByBarcode) {
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
    return options;
  }

  List<SortItems<Good>> getGoodSortOptions() {
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
    switch (_effectiveSortByBarcode) {
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
    return options;
  }

  /*void loadItems() async{
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
    switch (_effectiveSortByBarcode) {
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
    switch (_effectiveSortByBarcode) {
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
  }*/
  Future<void> deleteGood(int id) async {
    await goodsUseCase.delete(id);
    loadData();
    //loadItems();
  }

  Future<void> deleteGroup(int id) async {
    await groupsUseCase.delete(id);
    loadData();
    //loadItems();
  }

  /*List<Group> filterGroups(){
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
  }*/

  void moveGoodToGroup(Good item, int? groupId) {
    item.groupId = groupId;
    goodsUseCase.update(item);
    loadData();
    //loadItems();
  }

  void moveGroupToGroup(Group item, int? groupId) {
    item.groupId = groupId;
    groupsUseCase.update(item);
    loadData();
    //loadItems();
  }

  void addTransaction(int goodId, double quantity, double price) async {
    DocumentTransaction transaction = DocumentTransaction();
    transaction.documentId = state.document!.id!;
    transaction.goodId = goodId;
    transaction.quantity = quantity;
    transaction.price = price;
    transaction.type = state.document!.type;
    transaction.storeId = AppSettings.getSelectedStoreId();
    int transactionId;
    try {
      transactionId = await documentsUseCases.insertTransaction(transaction);
    } on InsufficientStockException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(state: InsufficientStockError(e)));
      return;
    }
    if (isClosed) return;
    if (transactionId > 0) {
      if (transaction.type == DocumentType.incoming) {
        emit(
          state.copyWith(
            state: InsertTransactionSuccessState(goodId, quantity),
          ),
        );
      } else {
        emit(
          state.copyWith(
            state: InsertTransactionSuccessState(goodId, -quantity),
          ),
        );
      }
    } else {
      emit(state.copyWith(state: InsertTransactionFailedState()));
    }
  }

  void updateQuantity(int goodId, double quantity) {
    if (isClosed) return;
    List<Good> goods = [];
    goods.addAll(state.allGoods);
    for (Good item in goods) {
      if (item.id == goodId) {
        item.quantity += quantity;
        break;
      }
    }
    emit(state.copyWith(allGoods: goods));
    refresh();
    //filter();
  }

  void resetAllFilter() {
    applyFilter(GoodsSetting.getDefault());
  }

  void resetListSettings() {
    applyFilter(
      state.settings.copyWith(
        hideZeroEntries: false,
        showBarcode: true,
        showDescription: true,
        showPurchasePrice: true,
        purchaseDisplayMode: PriceDisplayMode.price,
        showSalePrice: true,
        saleDisplayMode: PriceDisplayMode.price,
        showMinQuantity: true,
        gridColumnCount: 1,
      ),
    );
  }

  void resetSortOptions() {
    applyFilter(
      state.settings.copyWith(
        sortByName: SortByText.no_sort,
        sortByBarcode: SortByNumber.no_sort,
        sortByQuantity: SortByNumber.no_sort,
      ),
    );
  }

  void applyFilter(GoodsSetting setting) {
    emit(state.copyWith(settings: setting));
    AppSettings.setGoodsSetting(setting);
    refresh();
  }

  Future<int> importGoodsFromExcel({
    required Uint8List bytes,
    required String? fileName,
    required ExcelColumnMapping mapping,
  }) async {
    final rows = GoodsExcelImportParser.parse(
      bytes: bytes,
      fileName: fileName,
      mapping: mapping,
    );
    if (rows.isEmpty) return 0;

    final groupId = getSelectedGroupId();
    final storeId = AppSettings.getSelectedStoreId();
    var importedCount = 0;

    for (final row in rows) {
      final item = Good()
        ..name = row.name
        ..description = row.description ?? ''
        ..barCode = row.barcode
        ..purchasePrice = row.purchasePrice
        ..salePrice = row.salePrice
        ..minQuantity = row.minQuantity
        ..groupId = groupId
        ..storeId = storeId;
      try {
        final id = await goodsUseCase.insert(item);
        if (id > 0) importedCount++;
      } on DuplicateBarcodeException {
        // "Unique barcode" is on: skip rows whose barcode is already used
        // (by an existing Good or by an earlier row of this file).
        continue;
      }
    }

    if (importedCount > 0) {
      loadData();
    }
    return importedCount;
  }

  Uint8List? exportGoodsToExcel(ExcelColumnMapping mapping) {
    final groupId = getSelectedGroupId();
    var goods =
        state.allGoods.where((item) => item.groupId == groupId).toList();
    goods = getGoodWithSortOption(goods, getGoodSortOptions());
    if (goods.isEmpty) return null;
    return GoodsExcelExportBuilder.build(goods: goods, mapping: mapping);
  }

  String excelExportFileName() {
    final raw =
        state.selectedGroups.isEmpty ? 'goods' : state.selectedGroups.last.name;
    final safe = raw.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    return '${safe.isEmpty ? 'goods' : safe}.xlsx';
  }
}
