import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base_list_controller.dart';
import 'package:good_manager/app/pages/help_content.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/expenses_settings.dart';

import '../pages.dart';
import 'expenses_presenter.dart';
class ExpensesController
    extends BaseListController<Expense, ExpensesSettings, ExpensesPresenter> {
  ExpensesController(repository) : super(ExpensesPresenter(repository), false);

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

  @override
  HelpType getHelpType() {
    return HelpType.EXPENSE;
  }

  @override
  String getTitle() {
    return AppLocalizations.of(getContext()).expenses_title;
  }
}
