import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/suppliers/sort_supplier_dialog.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';

class SuppliersController extends Controller {
  bool isLoading = false;
  SuppliersPresenter _presenter;
  List<Supplier> _allItems;
  List<Supplier> _items;
  bool _isSelection;
  String _textSearch;

  SupplierSettings _settings;

  List<Supplier> get items => _items;

  SuppliersController(supplierRepository, this._isSelection)
      : _presenter = SuppliersPresenter(supplierRepository),
        super() {
    _allItems = [];
    _items = [];
    _textSearch = "";
    isLoading = true;
    _presenter.getSettings();
    _presenter.getSuppliers();
  }

  bool isNoSort() {
    if (_settings != null) {
      return (_settings.sortByName == SortByText.no_sort);
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
    _presenter.getSupplierSettingsOnError = (e) {
      showErrorToast(e.toString());
    };

    _presenter.setSupplierSettingsOnError = (e) {
      showErrorToast(e.toString());
    };
    _presenter.setSupplierSettingsOnComplete = () {
      refreshItems();
    };

    _presenter.getSuppliersOnNext = (List<Supplier> suppliers) {
      isLoading = false;
      _allItems = suppliers;
      refreshItems();
    };
    _presenter.getSuppliersOnError = (e) {
      isLoading = false;
      showErrorToast(e.toString());
      refreshUI();
    };
    //delete
    _presenter.deleteSupplierOnComplete = () {
      int index =
          _allItems.indexWhere((element) => element.id == _presenter.deletedId);
      _allItems.removeAt(index);
      refreshItems();
    };
    _presenter.deleteSupplierOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  void onAddItem() async {
    final result = await Navigator.of(getContext())
        .pushNamed(Pages.save_supplier, arguments: {"item": Supplier()});
    if (result != null) {
      _allItems.add(result);
      refreshItems();
    }
  }

  void onItemPressed(Supplier supplier) async {
    if (_isSelection) {
      Navigator.of(getContext()).pop(supplier);
    } else {
      final result = await Navigator.of(getContext())
          .pushNamed(Pages.save_supplier, arguments: {'item': supplier});
      if (result != null) {
        int index =
            _allItems.indexWhere((element) => element.id == supplier.id);
        _allItems[index] = result;
        refreshItems();
      }
    }
  }

  void onItemLongPressed(Supplier supplier) async {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  if (supplier.numberDocument > 0) {
                    showCanNotDeleteDialog();
                  } else {
                    showDeleteConfirmDialog(supplier.id);
                  }
                },
                child: Text(AppLocalizations.of(getContext()).action_delete),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  //TODO
                },
                child: Text(
                    AppLocalizations.of(getContext()).action_view_transaction),
              )
            ],
          );
        },
        barrierDismissible: true);
  }

  void showCanNotDeleteDialog() {
    showDialog(
        context: getContext(),
        builder: (BuildContext builder) => AlertDialog(
              title: Text(
                  AppLocalizations.of(getContext()).notification_dialog_title),
              content: Text(AppLocalizations.of(getContext())
                  .message_delete_supplier_error_having_document),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: const Text('OK'),
                )
              ],
            ));
  }

  void showDeleteConfirmDialog(int id) {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(AppLocalizations.of(getContext())
                .message_confirm_delete_supplier),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: Text(AppLocalizations.of(getContext()).action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(getContext());
                  _presenter.delete(id);
                },
                child: Text(AppLocalizations.of(getContext()).action_ok),
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void setTextSearch(String textSearch) {
    _textSearch = textSearch;
    refreshItems();
  }

  void refreshItems() {
    filter();
    sort();
    refreshUI();
  }

  void filter() {
    _items.clear();
    if (_textSearch.isEmpty) {
      _items = _allItems.toList();
    } else {
      _allItems.forEach((element) {
        if (element.name.startsWith(_textSearch)) {
          _items.add(element);
        }
      });
    }
  }

  void sort() {
    switch (_settings.sortByName) {
      case SortByText.no_sort:
        {
          _items.sort((item1, item2) {
            return item1.name.compareTo(item2.name);
          });
          break;
        }
      case SortByText.a_to_z:
        {
          _items.sort((item1, item2) {
            return item1.name.compareTo(item2.name);
          });
          break;
        }
      case SortByText.z_to_a:
        {
          _items.sort((item1, item2) {
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
              _presenter.setSettings(_settings);
            }),
        barrierDismissible: true);
  }
}
