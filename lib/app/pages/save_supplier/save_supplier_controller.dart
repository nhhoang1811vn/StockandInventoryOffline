import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_presenter.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

class SaveSupplierController extends Controller{
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController addressTextController;
  TextEditingController emailTextController;
  TextEditingController phoneTextController;
  TextEditingController taxIDTextController;
  TextEditingController bankDetailsTextController;
  //

  final Supplier _item;
  final bool _isInsert;
  final SaveSupplierPresenter _presenter;
  bool isLoading = false;
  SaveSupplierController(supplierRepository,this._isInsert, this._item) : _presenter = SaveSupplierPresenter(supplierRepository),
        super(){
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    addressTextController = TextEditingController();
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    taxIDTextController = TextEditingController();
    bankDetailsTextController = TextEditingController();

    nameTextController.text = _item.name;
    descriptionTextController.text = _item.description;
    addressTextController.text = _item.address;
    emailTextController.text = _item.email;
    phoneTextController.text = _item.phone;
    taxIDTextController.text =_item.taxID;
    bankDetailsTextController.text = _item.bankDetail;
    isLoading = false;
  }
  @override
  void initListeners() {
    _presenter.insertSupplierOnError = (e) {
      //showGenericSnackbar(getStateKey(), e.message, isError: true);
    };
    _presenter.insertSupplierOnComplete = () {
      Navigator.of(getContext()).pop(true);
    };

    _presenter.updateSupplierOnError = (e) {
      //showGenericSnackbar(getStateKey(), e.message, isError: true);
    };
    _presenter.updateSupplierOnComplete = () {
      Navigator.of(getContext()).pop(true);
    };
  }
  void dismissLoading() {
    isLoading = false;
    refreshUI();
  }
  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
  void checkForm(Map<String, dynamic> params){
    dynamic formKey = params['formKey'];
    // Validate params
    assert(formKey is GlobalKey<FormState>);
    if (formKey.currentState.validate()) {
      _item.name = nameTextController.text;
      _item.description = descriptionTextController.text;
      _item.address = addressTextController.text;
      _item.email = emailTextController.text;
      _item.phone = phoneTextController.text;
      _item.taxID = taxIDTextController.text;
      _item.bankDetail = bankDetailsTextController.text;
      if (_isInsert){
        _presenter.insert(_item);
      }else{
        _presenter.update(_item);
      }
    } else {

    }
  }
}