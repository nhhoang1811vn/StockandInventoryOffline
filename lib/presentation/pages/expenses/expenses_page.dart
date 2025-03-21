import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/expenses_setting.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart';
import 'package:good_manager/presentation/pages/expenses/components/expense_item_row.dart';
import 'package:good_manager/presentation/pages/expenses/components/sort_expenses_dialog.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:sprintf/sprintf.dart';

import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';

class ExpensesPage extends StatefulWidget {
  ExpensesPage({Key? key}) : super(key: key);

  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends BaseStateWidget<ExpensesPage> {
  final FocusNode searchTextFocusNode = FocusNode();
  final TextEditingController searchTextController = TextEditingController();

  @override
  bool hasDrawer() {
    return true;
  }
  @override
  void initState() {
    super.initState();
    context.read<ExpensesCubit>().init();
  }


  PreferredSize _buildAppBar(ExpensesState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
          title: new Text(AppLocalizations.of(context)!.expenses_title),
          actions: [_buildSearchMenu(state), _buildSortMenu(), _buildHelpMenu()]),
    );
  }
  Widget _buildSearchMenu(ExpensesState state){
    return IconButton(onPressed: (){
      searchTextController.text = "";
      if (!state.showSearchBar){
        searchTextFocusNode.requestFocus();
      }
      context.read<ExpensesCubit>().onShowSearchBarMenuClicked();
    }, icon: Icon(Icons.search, color: state.showSearchBar
        ? UIConstants.highlightMenuColor
        : UIConstants.normalMenuColor ,));
  }
  Widget _buildSortMenu(){
    return IconButton(onPressed: (){
      context.read<ExpensesCubit>().onSortMenuClicked();
    }, icon: Icon(Icons.sort, color: context.read<ExpensesCubit>().hasSortOptions()
        ? UIConstants.highlightMenuColor
        : UIConstants.normalMenuColor));
  }
  Widget _buildHelpMenu(){
    return IconButton(onPressed: (){
      context.read<ExpensesCubit>().onHelpMenuClick();
    }, icon: Icon(Icons.help));
  }

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

  Widget _buildContent(ExpensesState data) {
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
          focusNode: searchTextFocusNode,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.search_by_name, border: InputBorder.none),
          onChanged: context.read<ExpensesCubit>().searchTextChanged,
          controller: searchTextController,
        ),
        trailing: Visibility(
          child: IconButton(
              icon: Icon(UIConstants.cancelIconData),
              onPressed: () {
                searchTextController.text = "";
                context.read<ExpensesCubit>().resetSearchText();
              }),
          visible: data.textSearch.isNotEmpty,
        ),
      ),
    );
  }

  Widget get emptyView =>
      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Icon(UIConstants.expenseIconData, size: 60, color: AppColors.primaryColor,),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
                AppLocalizations.of(context)!.empty_expense,
                textAlign: TextAlign.center,
                style: AppStyle.getEmptyTextStyle(),
            ))
      ]);

  Widget _buildListView(ExpensesState data) => ListView.builder(
      itemBuilder: (BuildContext context, index) {
        Expense item = data.items[index];
        return ExpenseItemRow(item, (item) {
          onPressed(item);
        }, (item) {
          onLongPressed(item);
        });
      },
      // separatorBuilder: (context, index) {
      //   return Divider(color: Colors.grey[500]);
      // },
      itemCount: data.items.length);

  void onPressed(Expense item) async {
    final result = await Navigator.of(context).pushNamed(Pages.save_expense, arguments: {"item": item});
    if (result != null) {
      context.read<ExpensesCubit>().loadItems();
    }
  }
  void onLongPressed(Expense item){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteExpenseConfirmPopup(item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }
  void showDeleteExpenseConfirmPopup(Expense item) async{
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(context)!.message_confirm_delete,
                [item.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () async{
                  await context.read<ExpensesCubit>().delete(item.id!);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return BlocConsumer<ExpensesCubit, ExpensesState>(
        builder: (context, state) => Scaffold(
            key: ScaffoldKey,
            appBar: _buildAppBar(state),
            body: _buildBody(state),
            floatingActionButton: FloatingActionButton(
              onPressed: context.read<ExpensesCubit>().onAddItem,
              child: Icon(Icons.add),
            )),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {
          if (state.state is OpenSortDialogListState) {
            ExpensesSetting settings = await showDialog(
                context: context,
                builder: (_) => SortExpensesDialog(state.settings),
                barrierDismissible: true);
            context.read<ExpensesCubit>().setSettings(settings);
          } else if (state.state is OpenHelpPageState) {
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.expenses_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.EXPENSE)
            });
          } else if (state.state is OpenSaveExpensePageState) {
            final currentState = state.state as OpenSaveExpensePageState;
            final result =
                await Navigator.of(context).pushNamed(Pages.save_expense, arguments: {"item": currentState.item});
            if (result != null) {
              context.read<ExpensesCubit>().loadItems();
            }
          }
        });
  }
}
