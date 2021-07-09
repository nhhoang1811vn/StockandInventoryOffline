import 'package:flutter/widgets.dart';
import 'package:good_manager/app/pages/base_list_controller.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/expenses_settings.dart';

import '../pages.dart';
import 'expenses_presenter.dart';

class ExpensesController
    extends BaseListController<Expense, ExpensesSettings, ExpensesPresenter> {
  ExpensesController(repository) : super(ExpensesPresenter(repository));

  @override
  bool filterItem(Expense item, String textSearch) {
    return item.name.contains(textSearch);
  }

  @override
  Expense getEmptyItem() {
    return Expense();
  }

  @override
  String getSaveItemRouteName() {
    return Pages.save_expense;
  }

  void onOpenHelpPage() {
    Navigator.of(getContext()).pushNamed(Pages.help,
        arguments: {"title": "Stores", "content": "Help of store content"});
  }
}
