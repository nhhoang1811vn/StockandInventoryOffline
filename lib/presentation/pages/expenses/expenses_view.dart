import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart';

import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';

class ExpensesPage extends StatefulWidget {
  ExpensesPage({Key? key}) : super(key: key);

  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends State<ExpensesPage> {
  PreferredSize _buildAppBar(ExpensesState state){
    return PreferredSize(
      preferredSize: Size.fromHeight(70), child:  AppBar(
        title: new Text(AppLocalizations.of(context)!.expenses_title),
        actions: [_buildSearchMenu(state), _buildSortMenu(state), helpMenu]),
    );
  }

  Widget _buildSearchMenu(ExpensesState state) => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: state.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: context.read<ExpensesCubit>().onShowSearchBarMenuClicked,
          ),
        );


  Widget _buildSortMenu(ExpensesState data) => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: context.read<ExpensesCubit>().hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: context.read<ExpensesCubit>().onSortMenuClicked,
          ),
        );


  Widget get helpMenu => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: context.read<ExpensesCubit>().onHelpMenuClick,
          ),
        );
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildBody(ExpensesState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }
  Widget _buildContent(ExpensesState data){
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

  Widget _buildSearchBar(ExpensesState data) {
    return Card(
      child: ListTile(
        title: TextField(
          decoration: InputDecoration(
              hintText: "by name", border: InputBorder.none),
          onChanged: context.read<ExpensesCubit>().searchTextChanged,
          //controller: controller.searchTextController,
        ),
        trailing: Visibility(
          child: IconButton(
            icon: Icon(UIConstants.cancelIconData),
            onPressed: context.read<ExpensesCubit>().resetSearchText,
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

  Widget _buildListView(ExpensesState data) =>  ListView.separated(
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpensesCubit, ExpensesState>(
        builder: (context, state) => Scaffold(
          //key: globalKey,
            drawer: CustomNavigationDrawer(selectedIndex: 3),
            appBar: _buildAppBar(state),
            body: _buildBody(state),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {},
              child: Icon(Icons.add),
            )),
        listenWhen: (p1, p2) => p1.state != p2.state,
    listener: (context, state) async{

    });
  }
}
