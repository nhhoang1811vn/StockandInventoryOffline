import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/suppliers/sort_supplier_dialog.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_presenter.dart';
import 'package:good_manager/domain/entities/Supplier.dart';
import 'package:good_manager/domain/entities/sort_by.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';
import 'package:good_manager/domain/usecases/suppliers/delete_supplier_usecase.dart';

class SuppliersController extends Controller {
  TextEditingController searchTextController;
  bool isLoading = false;
  SuppliersPresenter _presenter;
  List<Supplier> _filteredItems;
  List<Supplier> _items;
  bool _isSelection;
  String _textSearch;

  SupplierSettings _settings;

  List<Supplier> get items => _items;

  List<Supplier> get filteredItems => _filteredItems;

  SuppliersController(supplierRepository, documentRepository, this._isSelection)
      : _presenter = SuppliersPresenter(supplierRepository, documentRepository),
        super() {
    _items = [];
    _filteredItems = [];
    _textSearch = "";
    isLoading = true;
    searchTextController = TextEditingController();
    retrieveData();
  }

  void retrieveData() {
    _presenter.getSettings();
    _presenter.getSuppliers();
  }

  bool isNoSort() {
    if (_settings != null) {
      return (_settings.sortByName == SortBy.no_sort);
    } else {
      return true;
    }
  }

  @override
  void initListeners() {
    _presenter.getSupplierSettingsOnNext = (SupplierSettings settings) {
      _settings = settings;
      refreshUI();
    };
    _presenter.getSupplierSettingsOnComplete = () {};
    _presenter.getSupplierSettingsOnError = (e) {};

    _presenter.setSupplierSettingsOnError = (e) {};
    _presenter.setSupplierSettingsOnComplete = () {};

    _presenter.getSuppliersOnNext = (List<Supplier> suppliers) {
      _items = suppliers;
      refreshItems();
    };
    _presenter.getSuppliersOnError = (e) {
      handleError(e);
    };
    _presenter.getSuppliersOnComplete = () {
      dismissLoading();
    };
    //delete
    _presenter.deleteSupplierOnNext = (DeleteSupplierUseCaseResult result) {
      switch (result) {
        case DeleteSupplierUseCaseResult.success:
          _presenter.getSuppliers();
          break;
        case DeleteSupplierUseCaseResult.un_success_have_document:
          break;
        case DeleteSupplierUseCaseResult.un_success_row_effect:
          break;
      }
    };
    _presenter.deleteSupplierOnComplete = () {};
    _presenter.deleteSupplierOnError = (e) {};
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
        arguments: {'isInsert': true});
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
    refreshItems();
  }

  void refreshItems() {
    filter();
    sort();
    refreshUI();
  }

  void filter() {
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
  }

  void sort() {
    switch (_settings.sortByName) {
      case SortBy.no_sort:
        {
          _filteredItems.sort((item1, item2) {
            return item1.name.compareTo(item2.name);
          });
          break;
        }
      case SortBy.a_to_z:
        {
          _filteredItems.sort((item1, item2) {
            return item1.name.compareTo(item2.name);
          });
          break;
        }
      case SortBy.z_to_a:
        {
          _filteredItems.sort((item1, item2) {
            return item2.name.compareTo(item1.name);
          });
          break;
        }
      default:
        {}
    }
  }

  void openHelpPage() {
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": "Nhà cung cấp",
      "content":
          "Bạn có thể lưu trữ danh sách các nhà cung cấp. Điền dữ liệu của họ bằng tay hoăc import từ Danh Bạ"
    });
  }

  void openSortByDialog() {
    showDialog(
        context: getContext(),
        builder: (_) => SortSupplierDialog(_settings, () {
              refreshItems();
              _presenter.setSettings(_settings);
              refreshUI();
            }),
        barrierDismissible: true);
  }

  void delete(int id) {
    _presenter.delete(id);
  }
}
