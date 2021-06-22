import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/supplier.dart';

class SaveSupplierController extends Controller{
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController addressTextController;
  TextEditingController emailTextController;
  TextEditingController phoneTextController;
  TextEditingController taxIDTextController;
  TextEditingController bankDetailsTextController;

  Supplier _item;
  final SaveSupplierPresenter _presenter;

  SaveSupplierController(supplierRepository, this._item)
      : _presenter = SaveSupplierPresenter(supplierRepository),
        super() {
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
    taxIDTextController.text = _item.taxID;
    bankDetailsTextController.text = _item.bankDetail;
  }
  @override
  void initListeners() {
    _presenter.insertSupplierOnError = (e) {
      showErrorToast(e.toString());
    };
    _presenter.insertSupplierOnNext = (supplierId) {
      _item.id = supplierId;
      Navigator.of(getContext()).pop(_item);
    };

    _presenter.updateSupplierOnError = (e) {
      showErrorToast(e.toString());
    };
    _presenter.updateSupplierOnComplete = () {
      Navigator.of(getContext()).pop(_item);
    };
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void checkForm(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];
    assert(formKey is GlobalKey<FormState>);
    if (formKey.currentState.validate()) {
      updateItem();
      if (_item.id == null) {
        _presenter.insert(_item);
      } else {
        _presenter.update(_item);
      }
    }
  }

  void updateItem() {
    _item.name = nameTextController.text;
    _item.description = descriptionTextController.text;
    _item.address = addressTextController.text;
    _item.email = emailTextController.text;
    _item.phone = phoneTextController.text;
    _item.taxID = taxIDTextController.text;
    _item.bankDetail = bankDetailsTextController.text;
  }
}