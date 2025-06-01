import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/presentation/pages/save_store/components/save_store_form.dart';

import '../../widgets/primary_button.dart';



class SaveStorePage extends StatefulWidget {
  final Store item;
  SaveStorePage({Key? key, required this.item}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SaveStorePageState();
  }
}
class SaveStorePageState extends State<SaveStorePage> {
  @override
  Widget build(BuildContext context) {
    context.read<SaveStoreCubit>().init(widget.item);
    return Scaffold(
      
      appBar: _buildAppBar(context),
      body: Column(children: [
        Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                children: [
                  Card(
                    child: SaveStoreForm(item: widget.item),
                  )
                ],
              ),
            )),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surface,
          child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
            context.read<SaveStoreCubit>().onSaveClicked();
          }),
        )
      ],)  //SaveStoreForm(item: widget.item)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_store_title),
        ));
  }
}
