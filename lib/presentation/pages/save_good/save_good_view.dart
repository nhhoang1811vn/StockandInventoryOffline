import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../../domain/entities/document.dart';
import '../../widgets/primary_button.dart';
import 'bloc/save_good_cubit.dart';
import 'components/save_good_form.dart';

class SaveGoodPage extends StatefulWidget{
  final Good item;
  final Document? document;
  final DocumentTransaction? transaction;
  SaveGoodPage({
    required this.item,
    this.document,
    this.transaction,
  });
  @override
  State<StatefulWidget> createState() {
    return SaveGoodPageState(item: item, document: document, transaction: transaction);
  }
}
class SaveGoodPageState extends BaseStateWidget<SaveGoodPage> {
  final Good item;
  final Document? document;
  final DocumentTransaction? transaction;
  SaveGoodPageState({
    required this.item,
    this.document,
    this.transaction,
  });


  @override
  Widget buildWidget(BuildContext context) {
    context.read<SaveGoodCubit>().init(item, document, transaction);
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _buildAppBar(context),
        body: Column(
            children: [
              SelectedStoreView(),
              Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(UIConstants.screenSpace),
                    child: Column(
                      children: [
                        Card(
                          color: Theme.of(context).colorScheme.surface,
                          child: SaveGoodForm(
                              item: item,
                              transaction: transaction),
                        )
                      ],
                    ),
                  )),
              //Expanded(child: ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.surface,
                child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
                  context.read<SaveGoodCubit>().onSaveClicked();
                }),
              )
            ]));
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(title: Text(AppLocalizations.of(context)!.save_goods_title), actions: <Widget>[
          IconButton(onPressed: (){
            context.read<SaveGoodCubit>().onHistoryClicked();
          }, icon: Icon(Icons.history))
        ]));
  }
}
