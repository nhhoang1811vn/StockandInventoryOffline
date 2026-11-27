import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/free_limits.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../util/revenuecat_purchase_manager.dart';
import '../../base/base_sort_items.dart';
import '../../contact_import/contact_import_service.dart';

part 'customers_cubit.freezed.dart';
part 'customers_state.dart';

@injectable
class CustomersCubit extends Cubit<CustomersState> {
  final CustomersUseCase useCase;

  CustomersCubit({required this.useCase})
      : super(
          CustomersState.initial(
            state: InitialState(),
            settings: AppSettings.getCustomersSetting(),
          ),
        );

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

  bool filterItem(Customer item, String textSearch) {
    return item.name.toLowerCase().contains(textSearch.toLowerCase());
  }

  void onAddButtonClicked() async {
    bool isValid = await isValidToAddMoreCustomer();
    if (isClosed) return;
    if (isValid) {
      Customer item = Customer();
      item.storeId = AppSettings.getSelectedStoreId();
      onAddItem(item);
    } else {
      emit(state.copyWith(state: OpenBuySubscriptionDialogState()));
    }
  }

  Future<void> onImportFromContactsClicked() async {
    if (!await isValidToAddMoreCustomer()) {
      if (isClosed) return;
      emit(state.copyWith(state: OpenBuySubscriptionDialogState()));
      return;
    }
    final fields = await ContactImportService.pickContact();
    if (isClosed || fields == null) return;
    final item = Customer()
      ..storeId = AppSettings.getSelectedStoreId()
      ..name = fields.name
      ..phone = fields.phone
      ..email = fields.email
      ..address = fields.address
      ..description = fields.description;
    onAddItem(item);
  }

  Future<bool> isValidToAddMoreCustomer() async {
    var storeId = AppSettings.getSelectedStoreId();
    int count = await useCase.getCount(storeId);
    bool isPro = await RevenueCatService.isPro();
    return count < FreeLimits.customerLimit || isPro;
  }

  void onAddItem(Customer item) {
    emit(state.copyWith(state: OpenSaveCustomerPageState(item)));
  }

  void setSettings(CustomersSetting settings) {
    AppSettings.setCustomersSetting(settings);
    emit(state.copyWith(settings: settings));
    sort();
    filter();
  }

  void loadItems() async {
    final storeId = AppSettings.getSelectedStoreId();
    List<Customer> allItems = await useCase.getAllByStoreId(storeId);
    if (isClosed) return;
    emit(state.copyWith(allItems: allItems));
    sort();
    filter();
  }

  void filter() {
    if (isClosed) return;
    List<Customer> items = filterCustomers();
    emit(state.copyWith(items: items));
  }

  List<Customer> filterCustomers() {
    List<Customer> results =
        state.allItems.where((element) => filterCustomer(element)).toList();
    return results;
  }

  bool filterCustomer(Customer item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    return item.name.toLowerCase().contains(state.textSearch.toLowerCase());
  }

  void sort() {
    if (isClosed) return;
    List<Customer> items = sortCustomers();
    emit(state.copyWith(allItems: items));
  }

  List<Customer> sortCustomers() {
    List<SortItems<Customer>> options = [];
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
    List<Customer> items = [];
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
    await useCase.delete(id);
    loadItems();
  }

  void resetAllFilter() {
    applyFilter(CustomersSetting.getDefault());
  }

  void applyFilter(CustomersSetting setting) {
    emit(state.copyWith(settings: setting));
    AppSettings.setCustomersSetting(setting);
    sort();
    filter();
  }
}
