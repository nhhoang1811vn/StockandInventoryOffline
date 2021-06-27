import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_presenter.dart';
import 'package:good_manager/domain/entities/supplier.dart';

class SaveSupplierController
    extends BaseSaveItemController<Supplier, SaveSupplierPresenter> {
  // Text field controller
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController addressTextController;
  TextEditingController emailTextController;
  TextEditingController phoneTextController;
  TextEditingController taxIDTextController;
  TextEditingController bankDetailsTextController;

  SaveSupplierController(repository, item)
      : super(SaveSupplierPresenter(repository), item) {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    addressTextController = TextEditingController();
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    taxIDTextController = TextEditingController();
    bankDetailsTextController = TextEditingController();
    nameTextController.text = item.name;
    descriptionTextController.text = item.description;
    addressTextController.text = item.address;
    emailTextController.text = item.email;
    phoneTextController.text = item.phone;
    taxIDTextController.text = item.taxID;
    bankDetailsTextController.text = item.bankDetail;
  }
  @override
  void updateItem() {
    item.name = nameTextController.text;
    item.description = descriptionTextController.text;
    item.address = addressTextController.text;
    item.email = emailTextController.text;
    item.phone = phoneTextController.text;
    item.taxID = taxIDTextController.text;
    item.bankDetail = bankDetailsTextController.text;
  }
}