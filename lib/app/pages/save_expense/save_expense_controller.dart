import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_expense/save_expense_presenter.dart';
import 'package:good_manager/domain/entities/expense.dart';

class SaveExpenseController
    extends BaseSaveItemController<Expense, SaveExpensePresenter> {
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  TextEditingController dateTextController;
  TextEditingController amountTextController;

  SaveExpenseController(repository, Expense item)
      : super(SaveExpensePresenter(repository), item) {
    nameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    dateTextController = TextEditingController();
    amountTextController = TextEditingController();

    nameTextController.text = item.name;
    descriptionTextController.text = item.description;
    dateTextController.text = item.date.toString();
    amountTextController.text = item.amount.toString();
  }

  @override
  void updateItem() {
    item.name = nameTextController.text;
    item.description = descriptionTextController.text;
    item.date = DateTime.parse(dateTextController.text);
    item.amount = double.parse(amountTextController.text);
  }
}
