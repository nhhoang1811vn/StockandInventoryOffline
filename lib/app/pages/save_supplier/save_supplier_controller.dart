import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/base/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_presenter.dart';
import 'package:good_manager/domain/entities/supplier.dart';

class SaveSupplierController
    extends BaseSaveItemController<Supplier, SaveSupplierPresenter> {
  TextEditingController addressTextController;
  TextEditingController emailTextController;
  TextEditingController phoneTextController;
  TextEditingController taxIDTextController;
  TextEditingController bankDetailsTextController;

  SaveSupplierController(repository, item)
      : super(SaveSupplierPresenter(repository), item) {
    addressTextController = TextEditingController();
    emailTextController = TextEditingController();
    phoneTextController = TextEditingController();
    taxIDTextController = TextEditingController();
    bankDetailsTextController = TextEditingController();
    addressTextController.text = item.address;
    emailTextController.text = item.email;
    phoneTextController.text = item.phone;
    taxIDTextController.text = item.taxID;
    bankDetailsTextController.text = item.bankDetail;
  }

  @override
  void updateItem() {
    super.updateItem();
    item.address = addressTextController.text;
    item.email = emailTextController.text;
    item.phone = phoneTextController.text;
    item.taxID = taxIDTextController.text;
    item.bankDetail = bankDetailsTextController.text;
  }

  @override
  Supplier getOriginalItem(Supplier item) {
    Supplier supplier = Supplier();
    supplier.name = item.name;
    supplier.description = item.description;
    supplier.address = item.address;
    supplier.email = item.email;
    supplier.phone = item.phone;
    supplier.taxID = item.taxID;
    supplier.bankDetail = item.bankDetail;

    return supplier;
  }

  @override
  bool hasChanged(Supplier item, Supplier originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description ||
        item.address != originalItem.address ||
        item.email != originalItem.email ||
        item.phone != originalItem.phone ||
        item.taxID != originalItem.taxID ||
        item.bankDetail != originalItem.bankDetail);
  }
}