import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/presentation/pages/save_store/components/save_store_form.dart';



class SaveStorePage extends StatefulWidget {
  final Store item;
  SaveStorePage({Key? key, required this.item}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SaveStorePageState();
  }
}
class SaveStorePageState extends BaseStateWidget<SaveStorePage> {
  @override
  Widget buildWidget(BuildContext context) {
    context.read<SaveStoreCubit>().init(widget.item);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SaveStoreForm(item: widget.item)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_store_title),
        actions: <Widget>[
          IconButton(onPressed: (){
            context.read<SaveStoreCubit>().onSaveClicked();
          }, icon:  Icon(Icons.check))
        ]));
  }
}
