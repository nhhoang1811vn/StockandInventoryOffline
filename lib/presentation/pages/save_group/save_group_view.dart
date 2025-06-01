import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:good_manager/presentation/pages/save_group/components/save_group_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../widgets/primary_button.dart';
class SaveGroupPage extends StatefulWidget{
  final Group item;
  SaveGroupPage({required this.item}) : super();
  @override
  State<StatefulWidget> createState() {
    return SaveGroupPageState();
  }
}
class SaveGroupPageState extends State<SaveGroupPage> {
  @override
  Widget build(BuildContext context) {
    context.read<SaveGroupCubit>().init(widget.item);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(children: [
          SelectedStoreView(),
          Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(UIConstants.screenSpace),
                child: Column(
                  children: [
                    Card(
                      child: SaveGroupForm(item: widget.item),
                    )
                  ],
                ),
              )),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surface,
            child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
              context.read<SaveGroupCubit>().onSaveClicked();
            }),
          )
        ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_group_title),
        ));
  }
}
