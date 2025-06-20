import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';

import '../../widgets/selected_store_view.dart';
class SelectGroupPage extends StatefulWidget{
  final int? id;
  final int? groupId;

  //if id is not null, meaning moving group
  //if id is null, meaning moving good
  SelectGroupPage(this.id, this.groupId) : super();

  @override
  State<StatefulWidget> createState() {
    return SelectGroupPageState();
  }
}
class SelectGroupPageState extends State<SelectGroupPage> {
  final TreeController _treeController =
      TreeController(allNodesExpanded: false);

  @override
  Widget build(BuildContext context) {
    context.read<SelectGroupCubit>().init(widget.id, widget.groupId);
    return BlocConsumer<SelectGroupCubit, SelectGroupState>(
        builder: (context, state) => Scaffold(
            appBar: _buildAppBar(context, state),
            body: Column(children: [
              SelectedStoreView(),
              Expanded(child: SingleChildScrollView(child: buildTree(context, state)))
            ])),
        listener: (context, state) => {});
  }

  PreferredSize _buildAppBar(BuildContext context, SelectGroupState state) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(
            title: Text(AppLocalizations.of(context)!.select_group_title),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop({"groupId": state.selectedGroupId});
                  },
                  icon: Icon(Icons.check))
            ]));
  }

  /// Builds tree or error message out of the entered content.
  Widget buildTree(BuildContext context, SelectGroupState state) {
    try {
      return TreeView(
        nodes: toTreeNodes(context, state, state.treeMap, state.items),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  List<TreeNode> toTreeNodes(BuildContext context, SelectGroupState state,
      Map<int, dynamic>? map, Map<int, Group>? data) {
    if (map != null)
      return map.keys
          .map((k) => TreeNode(
              content: _buildGroupRow(context, state, data?[k]),
              children: toTreeNodes(context, state, map[k], data)))
          .toList();
    return [];
  }

  Widget _buildGroupRow(
      BuildContext context, SelectGroupState state, Group? item) {
    return Expanded(
        child: InkWell(
            onTap: () => context.read<SelectGroupCubit>().select(item),
            child: Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              decoration: item?.id == state.selectedGroupId
                  ? BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.white,
                      ],
                    ))
                  : null,
              child: Row(
                children: [
                  Icon(UIConstants.groupIconData, size: 24, color: Theme.of(context).colorScheme.primary),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item?.name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      if (item?.description != '')...[

                        Text(item?.description ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface)),
                      ]

                    ],
                  )
                ],
              ),
            )));
  }
}
