import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:good_manager/app/pages/base/base_save_item_controller.dart';
import 'package:good_manager/app/pages/save_expense/save_expense_presenter.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/extension/date_time_apis.dart';

class SaveExpenseController
    extends BaseSaveItemController<Expense, SaveExpensePresenter> {
  TextEditingController dateTextController;
  TextEditingController amountTextController;

  SaveExpenseController(repository, Expense item)
      : super(SaveExpensePresenter(repository), item) {
    dateTextController = TextEditingController();
    amountTextController = TextEditingController();

    dateTextController.text = item.date.toString();
    amountTextController.text = item.amount.toString();
  }

  @override
  void updateItem() {
    super.updateItem();
    item.date = DateTime.parse(dateTextController.text);
    item.amount = double.parse(amountTextController.text);
  }

  void onOpenCalculator() async {
    /*final result = await showCalculator(context: getContext()) ?? 0;
    amountTextController.text = result.toInt().toString();*/
  }

  @override
  Expense getOriginalItem(Expense item) {
    Expense expense = Expense();
    expense.name = item.name;
    expense.description = item.description;
    expense.date = item.date;
    expense.amount = item.amount;
    return expense;
  }

  @override
  bool hasChanged(Expense item, Expense originalItem) {
    return (item.name != originalItem.name ||
        item.description != originalItem.description ||
        !item.date.isSameDate(originalItem.date) ||
        item.amount != originalItem.amount);
  }
}
