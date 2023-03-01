import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/expenses/expenses_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_expense_repository.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../main_page.dart';

class ExpensesPage extends View {
  ExpensesPage({Key key}) : super(key: key);

  @override
  ExpensesPageView createState() => ExpensesPageView();
}

class ExpensesPageView extends ViewState<ExpensesPage, ExpensesController> {
  ExpensesPageView() : super(ExpensesController(DataExpenseRepository()));

  @override
  Widget get view => Scaffold(
      key: globalKey,
      drawer: CustomNavigationDrawer(),
      appBar: appBar,
      body: ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return ModalProgressHUD(
            child: getBody(), inAsyncCall: controller.isLoading, opacity: 0);
      }),
      floatingActionButton: ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return FloatingActionButton(
          onPressed: () => controller.onAddItem(),
          child: Icon(Icons.add),
        );
      }));

  Widget get appBar => AppBar(
      title: new Text(AppLocalizations.of(context).expenses_title),
      actions: [searchMenu, sortMenu, helpMenu]);

  Widget get searchMenu => ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: controller.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: controller.toggleSearchBar,
          ),
        );
      });

  Widget get sortMenu => ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: controller.hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: controller.onShowSortDialog,
          ),
        );
      });

  Widget get helpMenu => ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: controller.onOpenHelpPage,
          ),
        );
      });

  Widget getBody() {
    List<Widget> children = [
      //StoreView(),
      ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return Visibility(child: searchBar, visible: controller.showSearchBar);
      }),
      ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return Expanded(
            child: Stack(children: [
          Visibility(
            child: emptyView,
            visible: controller.items.isEmpty && !controller.isLoading,
          ),
          Visibility(
            child: listView,
            visible: controller.items.isNotEmpty && !controller.isLoading,
          )
        ]));
      })
    ];
    return Column(children: children);
  }

  Widget get searchBar => ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "by name", border: InputBorder.none),
              onChanged: controller.onSearchChanged,
              controller: controller.searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                icon: Icon(UIConstants.cancelIconData),
                onPressed: controller.resetSearchText,
              ),
              visible: controller.textSearch.isNotEmpty,
            ),
          ),
        );
      });

  Widget get emptyView => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(
                  UIConstants.expenseIconPath,
                )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context).empty_expense,
                    textAlign: TextAlign.center))
          ]);

  Widget get listView => ControlledWidgetBuilder<ExpensesController>(
          builder: (context, controller) {
        return ListView.separated(
            itemBuilder: (BuildContext context, index) {
              Expense item = controller.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: item.amount > 0
                    ? getPositiveAmount(item.amount)
                    : getNegativeAmount(item.amount),
                onTap: () => controller.onItemPressed(controller.items[index]),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: controller.items.length);
      });

  Widget getPositiveAmount(amount) {
    return Text(
      "+ $amount",
      style: TextStyle(color: Colors.green),
    );
  }

  Widget getNegativeAmount(amount) {
    return Text(
      amount.toString(),
      style: TextStyle(color: Colors.red),
    );
  }
}
