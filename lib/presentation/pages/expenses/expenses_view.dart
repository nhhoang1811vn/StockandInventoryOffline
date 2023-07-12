import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/base/base_page.dart';
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart';
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_data.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/expense.dart';

import 'package:good_manager/app/widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';

class ExpensesPage extends StatefulWidget {
  ExpensesPage({Key? key}) : super(key: key);

  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends BasePageState<ExpensesPage, ExpensesCubit, ExpensesData> {
  @override
  Widget buildPage(BuildContext context, ExpensesData data) {
    return Scaffold(
        //key: globalKey,
        drawer: CustomNavigationDrawer(selectedIndex: 3),
        appBar: _buildAppBar(data),
        body: _buildBody(data),
        floatingActionButton: FloatingActionButton(
                onPressed: () => {},
                child: Icon(Icons.add),
              ));
  }
  PreferredSize _buildAppBar(ExpensesData data){
    return PreferredSize(
      preferredSize: Size.fromHeight(70), child:  AppBar(
        title: new Text(AppLocalizations.of(context)!.expenses_title),
        actions: [_buildSearchMenu(data), _buildSortMenu(data), helpMenu]),
    );
  }

  Widget _buildSearchMenu(ExpensesData data) => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: data.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: cubit.onShowSearchBarMenuClicked,
          ),
        );


  Widget _buildSortMenu(ExpensesData data) => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: cubit.hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: cubit.onSortMenuClicked,
          ),
        );


  Widget get helpMenu => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: cubit.onHelpMenuClick,
          ),
        );
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildBody(ExpensesData data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }
  Widget _buildContent(ExpensesData data){
    List<Widget> children = [
      SelectedStoreView(),
      Visibility(child: _buildSearchBar(data), visible: data.showSearchBar),
      Expanded(
                child: Stack(children: [
                  Visibility(
                    child: emptyView,
                    visible: data.items.isEmpty,
                  ),
                  Visibility(
                    child: _buildListView(data),
                    visible: data.items.isNotEmpty,
                  )
                ]))
    ];
    return Column(children: children);
  }

  Widget _buildSearchBar(ExpensesData data) {
    return Card(
      child: ListTile(
        title: TextField(
          decoration: InputDecoration(
              hintText: "by name", border: InputBorder.none),
          onChanged: cubit.searchTextChanged,
          //controller: controller.searchTextController,
        ),
        trailing: Visibility(
          child: IconButton(
            icon: Icon(UIConstants.cancelIconData),
            onPressed: cubit.resetSearchText,
          ),
          visible: data.textSearch.isNotEmpty,
        ),
      ),
    );
  }

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
                child: Text(AppLocalizations.of(context)!.empty_expense,
                    textAlign: TextAlign.center))
          ]);

  Widget _buildListView(ExpensesData data) =>  ListView.separated(
            itemBuilder: (BuildContext context, index) {
              Expense item = data.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: item.amount > 0
                    ? getPositiveAmount(item.amount)
                    : getNegativeAmount(item.amount),
                //onTap: () => cubit.onItemPressed(data.items[index]),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: data.items.length);

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
