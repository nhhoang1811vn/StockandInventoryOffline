import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:good_manager/presentation/pages/save_group/components/save_group_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
class SaveGroupPage extends StatefulWidget{
  final Group item;
  SaveGroupPage({required this.item}) : super();
  @override
  State<StatefulWidget> createState() {
    return SaveGroupPageState();
  }
}
class SaveGroupPageState extends BaseStateWidget<SaveGroupPage> {
  @override
  Widget buildWidget(BuildContext context) {
    context.read<SaveGroupCubit>().init(widget.item);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(children: [
          SelectedStoreView(),
          Expanded(child: SaveGroupForm(item: widget.item))
        ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_group_title),
        actions: <Widget>[
          IconButton(onPressed: (){
            context.read<SaveGroupCubit>().onSaveClicked();
          }, icon: Icon(Icons.check))
        ]));
  }
}
