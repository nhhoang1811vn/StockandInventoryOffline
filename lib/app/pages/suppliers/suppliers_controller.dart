import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_presenter.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

class SuppliersController extends Controller{
  bool isLoading = false;
  SuppliersPresenter _presenter;
  List<Supplier> _suppliers;
  bool _isSelection;

  List<Supplier> get suppliers => _suppliers;
  SuppliersController(supplierRepository, this._isSelection) : _presenter = SuppliersPresenter(supplierRepository), super(){
    _suppliers = [];
    isLoading = true;
    retrieveData();
  }
  void retrieveData() {
    _presenter.getSuppliers();
  }
  @override
  void initListeners() {
    _presenter.getSuppliersOnNext = (List<Supplier> suppliers) {
      _suppliers = suppliers;
    };
    _presenter.getSuppliersOnError = (e) {
      handleError(e);
    };
    _presenter.getSuppliersOnComplete = () {
      dismissLoading();
    };
  }
  void dismissLoading(){
    isLoading = false;
    refreshUI();
  }
  void handleError(e){
    dismissLoading();
  }

  void onAddItem(){
    Navigator.of(getContext()).pushNamed(Pages.save_supplier,arguments: {
      'item': Supplier.origin(),
      'isInsert' : true
    });
  }
  void onItemPressed(Supplier supplier){
    if (_isSelection){
      Navigator.of(getContext()).pop(supplier);
    }else{
      Navigator.of(getContext()).pushNamed(Pages.save_supplier, arguments: {
        'item': supplier,
        'isInsert' : false
      });
    }
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}