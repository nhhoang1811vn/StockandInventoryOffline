import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/util/util.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/free_limits.dart';
import '../../base/base_sort_items.dart';
import '../../base/base_state.dart';

part 'stores_cubit.freezed.dart';
part 'stores_state.dart';

@injectable
class StoresCubit extends Cubit<StoresState> {
  final StoresUseCase useCase;

  StoresCubit({required this.useCase})
      : super(
          StoresState.initial(
            state: InitialState(),
            settings: AppSettings.getStoresSetting(),
          ),
        );

  //final purchaseManager = PurchaseManager();
  void initState(bool isSelection) {
    emit(state.copyWith(isSelection: isSelection, showSearchBar: isSelection));
    loadItems();
  }

  void searchTextChanged(String value) {
    emit(state.copyWith(textSearch: value));
    filter();
  }

  void resetSearchText() {
    emit(state.copyWith(textSearch: ""));
    filter();
  }

  void onShowSearchBarMenuClicked() {
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
    resetSearchText();
  }

  bool hasSortOptions() {
    return (state.settings.sortByName != SortByText.no_sort);
  }

  void onHelpMenuClick() {
    emit(state.copyWith(state: OpenHelpPageState()));
  }

  void onAddButtonClicked() async {
    bool isValid = await isValidToAddMoreStore();
    if (isValid) {
      Store item = Store();
      onAddItem(item);
    } else {
      emit(state.copyWith(state: OpenBuySubscriptionDialogState()));
    }
  }

  Future<bool> isValidToAddMoreStore() async {
    int count = await useCase.getCount();
    bool isPro = await RevenueCatService.isPro();
    return count < FreeLimits.storeLimit || isPro;
  }

  void onAddItem(Store item) {
    emit(state.copyWith(state: OpenSaveStorePageState(item)));
  }

  // void setSettings(StoresSetting settings) {
  //   appSettings.setStoresSetting(settings);
  //   emit(state.copyWith(settings: settings));
  //   sort();
  //   filter();
  // }
  void loadItems() async {
    List<Store> allItems = await useCase.getAll();
    emit(state.copyWith(allItems: allItems));
    sort();
    filter();
  }

  void filter() {
    List<Store> items = filterStores();
    emit(state.copyWith(items: items));
  }

  List<Store> filterStores() {
    List<Store> results =
        state.allItems.where((element) => filterStore(element)).toList();
    return results;
  }

  bool filterStore(Store item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    return item.name.contains(state.textSearch);
  }

  void sort() {
    List<Store> items = sortStores();
    emit(state.copyWith(allItems: items));
  }

  List<Store> sortStores() {
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

  Future<void> delete(int id) async {
    bool result = await useCase.delete(id);
    if (result == false) {
      emit(state.copyWith(state: DeleteItemError()));
    } else {
      loadItems();
    }
  }

  void resetAllFilter() {
    applyFilter(StoresSetting.getDefault());
  }

  void applyFilter(StoresSetting setting) {
    emit(state.copyWith(settings: setting));
    AppSettings.setStoresSetting(setting);
    sort();
    filter();
  }

  int getSelectedStoreId() {
    return AppSettings.getSelectedStoreId();
  }
}
