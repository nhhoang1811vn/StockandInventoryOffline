
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/sort_by_text.dart';
import '../../../../domain/entities/suppliers_setting.dart';
import '../../../../domain/free_limits.dart';
import '../../../../domain/usecases/suppliers/suppliers_usecases.dart';
import '../../../../revenuecat_purchase_manager.dart';
import '../../base/base_sort_items.dart';

part 'suppliers_cubit.freezed.dart';
part 'suppliers_state.dart';

@injectable
class SuppliersCubit extends Cubit<SuppliersState> {
  final SuppliersUseCase useCase;
  final AppSettings appSettings;
  //final Storage storage;
  SuppliersCubit({
    required this.appSettings,
    //required this.storage,
    required this.useCase}) : super(SuppliersState.initial(state: InitialState(), settings: appSettings.getSuppliersSetting()));

  //final purchaseManager = PurchaseManager();
  void initState(bool isSelection){
    emit(state.copyWith(isSelection: isSelection, showSearchBar: isSelection));
    loadItems();
  }
  void searchTextChanged(String value){
    emit(state.copyWith(textSearch: value));
    filter();
  }
  void resetSearchText(){
    emit(state.copyWith(textSearch: ""));
    filter();
  }
  void onShowSearchBarMenuClicked(){
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
    resetSearchText();
  }
  bool hasSortOptions() {
    return (state.settings.sortByName != SortByText.no_sort);
  }
  void onSortMenuClicked(){
    emit(state.copyWith(state: OpenSortDialogListState()));
  }
  void onHelpMenuClick(){
    emit(state.copyWith(state: OpenHelpPageState()));
  }

  void showCanNotDeleteDialog() {
  }

  bool filterItem(Supplier item, String textSearch) {
    return item.name.toLowerCase().contains(textSearch.toLowerCase());
  }
  // void onAddButtonClicked() {
  //   Supplier item = Supplier();
  //   item.storeId = storage.getSelectedStoreId();
  //   onAddItem(item);
  // }

  void onAddButtonClicked() async{
    bool isValid = await isValidToAddMoreSupplier();
    if (isValid){
      Supplier item = Supplier();
      item.storeId = appSettings.getSelectedStoreId();
      onAddItem(item);
    }else{
      emit(state.copyWith(state: OpenBuySubscriptionDialogState()));
    }
  }
  Future<bool> isValidToAddMoreSupplier() async{
    var storeId = appSettings.getSelectedStoreId();
    int count = await useCase.getCount(storeId);
    bool isPro = await RevenueCatService.isPro();
    return count < FreeLimits.supplierLimit || isPro;
  }

  void onAddItem(Supplier item){
    emit(state.copyWith(state: OpenSaveSupplierPageState(item)));
  }
  void loadItems() async{
    final storeId = appSettings.getSelectedStoreId();
    List<Supplier> allItems = await useCase.getAllByStoreId(storeId);
    emit(state.copyWith(allItems: allItems));
    sort();
    filter();
  }
  void filter(){
    List<Supplier> items = filterSuppliers();
    emit(state.copyWith(items: items));
  }
  List<Supplier> filterSuppliers(){
    List<Supplier> results = state.allItems.where((element) => filterSupplier(element)).toList();
    return results;
  }
  bool filterSupplier(Supplier item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    return item.name.contains(state.textSearch);
  }
  void sort(){
    List<Supplier> items = sortSuppliers();
    emit(state.copyWith(allItems: items));
  }
  List<Supplier> sortSuppliers(){
    List<SortItems<Supplier>> options = [];
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

    if (options.isEmpty) {
      options.add(SortByCreatedDate());
    }
    List<Supplier> items = [];
    items.addAll(state.allItems);
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
  delete(int id) async{
    await useCase.delete(id);
    loadItems();
  }

  void resetAllFilter() {
    applyFilter(SuppliersSetting.getDefault());
  }

  void applyFilter(SuppliersSetting setting) {
    emit(state.copyWith(settings: setting));
    appSettings.setSuppliersSetting(setting);
    sort();
    filter();
  }
}
