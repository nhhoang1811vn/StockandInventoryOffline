import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';

import '../../../app/widgets/selected_store_view.dart';

class SelectGroupPage extends StatelessWidget {
  final int groupId;
  SelectGroupPage(this.groupId) : super();

  @override
  Widget build(BuildContext context) {
    context.read<SelectGroupCubit>().init(groupId);
    return BlocConsumer<SelectGroupCubit, SelectGroupState>(builder: (context, state) => Scaffold(
      appBar: _buildAppBar(context, state),
      body: Column(children: [
        SelectedStoreView(),
        Expanded(child: ListView.separated(
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                leading: Image.asset(
                  UIConstants.folderIconPath,
                  width: 24,
                ),
                title: Text(state.items[index].name),
                subtitle: Text(state.items[index].description),
                selected: index == state.selectedIndex,
                onTap: () => context.read<SelectGroupCubit>().select(index),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: state.items.length))
      ])), listener: (context, state) => {});
  }

  PreferredSize _buildAppBar(BuildContext context, SelectGroupState state){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.select_group_title),
        actions: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).pop(state.items[state.selectedIndex]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ]));
  }
}