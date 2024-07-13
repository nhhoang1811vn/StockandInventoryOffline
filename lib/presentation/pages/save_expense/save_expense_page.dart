import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/save_expense/bloc/save_expense_cubit.dart';
import 'package:good_manager/presentation/pages/save_expense/components/save_expense_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../../domain/entities/expense.dart';
class SaveExpensePage extends StatefulWidget{
  final Expense item;
  SaveExpensePage({Key? key, required this.item}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SaveExpensePageState();
  }
}
class SaveExpensePageState extends BaseStateWidget<SaveExpensePage> {

  @override
  Widget buildWidget(BuildContext context) {
    context.read<SaveExpenseCubit>().init(widget.item);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(children: [
          SelectedStoreView(),
          Expanded(child: SaveExpenseForm(item: widget.item))
        ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_expense_title),
        actions: <Widget>[
          IconButton(onPressed: (){
            context.read<SaveExpenseCubit>().onSaveClicked();
          }, icon: Icon(Icons.check))
        ]));
  }
}

