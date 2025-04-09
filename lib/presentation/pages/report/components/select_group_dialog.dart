import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';

class SelectGroupDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectGroupDialogState();
  }
}

class SelectGroupDialogState extends State<SelectGroupDialog> {
  final TreeController _treeController =
      TreeController(allNodesExpanded: false);

  @override
  Widget build(BuildContext context) {
    context.read<SelectGroupCubit>().init(null, null);
    return BlocConsumer<SelectGroupCubit, SelectGroupState>(
        builder: (context, state) => AlertDialog(
                title: Text("Pick group"),
                content: Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                            child: buildTree(context, state)))
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      child: Text(AppLocalizations.of(context)!.action_cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: Text(AppLocalizations.of(context)!.action_ok),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(
                            {"groupId": state.selectedGroupId, "groupName": state.selectedGroupName});
                      }),
                ]),
        listener: (context, state) => {});
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
              Image(image: AssetImage('assets/images/folder.png'), width: 24),
                  // Icon(
                  //   UIConstants.groupIconData,
                  //   size: 24,
                  //   color: UIConstants.primaryColor,
                  // ),
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
                                      Theme.of(context).colorScheme.onPrimary)),
                      if (item?.description != '') ...[
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
