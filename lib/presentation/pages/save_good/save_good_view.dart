
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../../domain/entities/document.dart';
import 'bloc/save_good_cubit.dart';
import 'components/save_good_form.dart';

class SaveGoodPage extends StatelessWidget {
  final Good item;
  final Document? document;
  final DocumentTransaction? transaction;

  SaveGoodPage({
    required this.item,
    this.document,
    this.transaction
  });


  @override
  Widget build(BuildContext context) {
    context.read<SaveGoodCubit>().init(item, document,transaction);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(children: [
          SelectedStoreView(),
          Expanded(child: SaveGoodForm(item: item, transaction: transaction))
        ])
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_goods_title),
        actions: <Widget>[
          InkWell(
            onTap: () => context.read<SaveGoodCubit>().onSaveClicked(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ]));
  }
}