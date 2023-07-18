import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/presentation/pages/save_store/components/save_store_form.dart';




class SaveStorePage extends StatelessWidget {
  final Store item;
  SaveStorePage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<SaveStoreCubit>().init(item);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SaveStoreForm(item: item)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_store_title),
        actions: <Widget>[
          InkWell(
            onTap: () => context.read<SaveStoreCubit>().onSaveClicked(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ]));
  }
}
