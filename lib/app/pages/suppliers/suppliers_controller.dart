import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_presenter.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

class SuppliersController extends Controller {
  //
  TextEditingController searchTextController;

  //
  bool isLoading = false;
  SuppliersPresenter _presenter;
  List<Supplier> _filteredItems;
  List<Supplier> _items;
  bool _isSelection;
  String _textSearch;

  List<Supplier> get items => _items;

  List<Supplier> get filteredItems => _filteredItems;

  SuppliersController(supplierRepository, this._isSelection)
      : _presenter = SuppliersPresenter(supplierRepository),
        super() {
    _items = [];
    _filteredItems = [];
    _textSearch = "";
    isLoading = true;
    searchTextController = TextEditingController();
    retrieveData();
  }

  void retrieveData() {
    _presenter.getSuppliers();
  }

  @override
  void initListeners() {
    _presenter.getSuppliersOnNext = (List<Supplier> suppliers) {
      _items = suppliers;
      refreshFilteredItems();
    };
    _presenter.getSuppliersOnError = (e) {
      handleError(e);
    };
    _presenter.getSuppliersOnComplete = () {
      dismissLoading();
    };
  }

  void dismissLoading() {
    isLoading = false;
    refreshUI();
  }

  void handleError(e) {
    dismissLoading();
  }

  void onAddItem() async {
    final result = await Navigator.of(getContext()).pushNamed(
        Pages.save_supplier,
        arguments: {'item': Supplier.origin(), 'isInsert': true});
    if (result) {
      isLoading = true;
      retrieveData();
    }
  }

  void onItemPressed(Supplier supplier) async {
    if (_isSelection) {
      Navigator.of(getContext()).pop(supplier);
    } else {
      final result = await Navigator.of(getContext()).pushNamed(
          Pages.save_supplier,
          arguments: {'item': supplier, 'isInsert': false});
      if (result) {
        isLoading = true;
        retrieveData();
      }
    }
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void setTextSearch(String textSearch) {
    searchTextController.text = textSearch;
    _textSearch = textSearch;
    refreshFilteredItems();
  }

  void refreshFilteredItems() {
    _filteredItems.clear();
    if (_textSearch.isEmpty) {
      _filteredItems = _items.toList();
    } else {
      _items.forEach((element) {
        if (element.name.startsWith(_textSearch)) {
          _filteredItems.add(element);
        }
      });
    }

    refreshUI();
  }

  void openHelpPage() {}

  void openSortByDialog() {}
}