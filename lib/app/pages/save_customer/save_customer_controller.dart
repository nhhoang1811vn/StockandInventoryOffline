import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_customer/save_customer_presenter.dart';
import 'package:good_manager/domain/entities/customer.dart';

class SaveCustomerController
    extends BaseSaveItemController<Customer, SaveCustomerPresenter> {
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController addressTextController;
  TextEditingController emailTextController;
  TextEditingController phoneTextController;
  TextEditingController taxIDTextController;
  TextEditingController bankDetailsTextController;

  SaveCustomerController(repository, item)
      : super(SaveCustomerPresenter(repository), item) {
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

  @override
  Customer getOriginalItem(Customer item) {
    Customer customer = Customer();
    customer.name = item.name;
    customer.description = item.description;
    customer.address = item.address;
    customer.email = item.email;
    customer.phone = item.phone;
    customer.taxID = item.taxID;
    customer.bankDetail = item.bankDetail;
    return customer;
  }

  @override
  bool hasChanged(Customer item, Customer originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description ||
        item.address != originalItem.address ||
        item.email != originalItem.email ||
        item.phone != originalItem.phone ||
        item.taxID != originalItem.taxID ||
        item.bankDetail != originalItem.bankDetail);
  }
}
