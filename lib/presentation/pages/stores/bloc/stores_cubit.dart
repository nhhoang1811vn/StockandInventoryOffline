import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/sort_by_text.dart';
import '../../../../domain/entities/stores_setting.dart';
import '../../base/base_sort_items.dart';
import '../../base/base_state.dart';

part 'stores_cubit.freezed.dart';
part 'stores_state.dart';

@injectable
class StoresCubit extends Cubit<StoresState> {
  final StoresUseCase useCase;
  final Storage storage;
  StoresCubit({required this.storage,required this.useCase}) : super(StoresState.initial(state: InitialState(), settings: storage.getStoresSetting()));

  void initState(bool isSelection){
    emit(state.copyWith(isSelection: isSelection, showSearchBar: isSelection));
    loadItems();
  }
  void searchTextChanged(String value){
    emit(state.copyWith(textSearch: value));
    filter();
    sort();
  }
  void resetSearchText(){
    emit(state.copyWith(textSearch: ""));
    filter();
    sort();
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
  void onAddButtonClicked() {
    Store item = Store();
    onAddItem(item);
  }
  void onAddItem(Store item){
    emit(state.copyWith(state: OpenSaveStorePageState(item)));
  }

  void setSettings(StoresSetting settings) {
    storage.setStoresSetting(settings);
    emit(state.copyWith(settings: settings));
    sort();
  }
  void loadItems() async{
    List<Store> allItems = await useCase.getAll();
    emit(state.copyWith(allItems: allItems));
    filter();
    sort();
  }
  void filter(){
    List<Store> items = filterStores();
    emit(state.copyWith(items: items));
  }
  List<Store> filterStores(){
    List<Store> results = state.allItems.where((element) => filterStore(element)).toList();
    return results;
  }
  bool filterStore(Store item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    return item.name.contains(state.textSearch);
  }

  void sort(){
    List<Store> items = sortStores();
    emit(state.copyWith(items: items));
  }
  List<Store> sortStores(){
    List<SortItems<Store>> options = [];
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
    List<Store> items = [];
    items.addAll(state.items);
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
}