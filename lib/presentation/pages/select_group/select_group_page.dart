import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';

import '../../widgets/selected_store_view.dart';

class SelectGroupPage extends StatelessWidget {
  final int? id;
  final int? groupId;

  //if id is not null, meaning moving group
  //if id is null, meaning moving good
  SelectGroupPage(this.id,this.groupId) : super();

  final TreeController _treeController = TreeController(allNodesExpanded: false);

  @override
  Widget build(BuildContext context) {
    context.read<SelectGroupCubit>().init(id,groupId);
    return BlocConsumer<SelectGroupCubit, SelectGroupState>(
        builder: (context, state) => Scaffold(
            appBar: _buildAppBar(context, state),
            body: Column(children: [SelectedStoreView(), Expanded(child: buildTree(context, state))])),
        listener: (context, state) => {});
  }

  PreferredSize _buildAppBar(BuildContext context, SelectGroupState state) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(title: Text(AppLocalizations.of(context)!.select_group_title), actions: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).pop({"groupId":state.selectedGroupId}),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ]));
  }

  /// Builds tree or error message out of the entered content.
  Widget buildTree(BuildContext context, SelectGroupState state) {
    try {
      return TreeView(
        nodes: toTreeNodes(context,state, state.treeMap, state.items),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  List<TreeNode> toTreeNodes(BuildContext context,SelectGroupState state, Map<int, dynamic>? map, Map<int, Group>? data) {
    if (map != null)
      return map.keys
          .map(
              (k) => TreeNode(content: _buildGroupRow(context,state, data?[k]), children: toTreeNodes(context, state, map[k], data)))
          .toList();
    return [];
  }
  Widget _buildGroupRow(BuildContext context, SelectGroupState state, Group? item){
    return Expanded(child: InkWell(
        onTap: () => context.read<SelectGroupCubit>().select(item?.id),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: item?.id == state.selectedGroupId ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.white,
                ],
              )
          ): null,
          child: Row(
            children: [
              Icon(UIConstants.groupIconData, size: 24, color: UIConstants.primaryColor,),
              SizedBox(
                width: 16,
              ),
              Column(
                children: [
                  Text(item?.name ?? '', style: AppStyle.getTitleListTitleStyle(),),
                  SizedBox(
                    height: 8,
                  ),
                  Text(item?.description ?? '',style: AppStyle.getSubTitleListTitleStyle()),
                ],
              )
            ],
          ),
        )));
  }

}
