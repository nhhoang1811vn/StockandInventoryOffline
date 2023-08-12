import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:good_manager/presentation/pages/save_group/components/save_group_form.dart';

class SaveGroupPage extends StatelessWidget {
  final Group item;
  SaveGroupPage({required this.item}) : super();

  @override
  Widget build(BuildContext context) {
    context.read<SaveGroupCubit>().init(item);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(children: [
          SelectedStoreView(),
          Expanded(child: SaveGroupForm(item: item))
        ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_group_title),
        actions: <Widget>[
          InkWell(
            onTap: context.read<SaveGroupCubit>().onSaveClicked,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ]));
  }
}
