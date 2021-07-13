import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/select_store/select_store_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/store.dart';

class SelectStoreController extends Controller {
  bool isLoading = false;
  SelectStorePresenter presenter;
  List<Store> items = [];
  int storeId;

  SelectStoreController(repository, this.storeId)
      : presenter = SelectStorePresenter(repository),
        super() {
    isLoading = true;
    items = [];
    presenter.getStores();
  }

  @override
  void initListeners() {
    presenter.getStoresOnNext = (stores) {
      items.addAll(stores);
      isLoading = false;
      refreshUI();
    };
    presenter.getStoresOnError = (e) {
      showErrorToast(e.toString());
      isLoading = false;
      refreshUI();
    };
  }

  void save() async {
    Navigator.of(getContext()).pop(storeId);
  }

  void select(int index) {
    storeId = items[index].id;
    refreshUI();
  }
}
