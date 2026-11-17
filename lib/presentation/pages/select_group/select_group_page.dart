import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';

class SelectGroupPage extends StatefulWidget {
  final int? id;
  final int? groupId;

  //null means the currently selected store
  final int? storeId;

  //if id is not null, meaning moving group
  //if id is null, meaning moving good
  SelectGroupPage(this.id, this.groupId, {this.storeId}) : super();

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
    final theme = Theme.of(context);
    context
        .read<SelectGroupCubit>()
        .init(widget.id, widget.groupId, storeId: widget.storeId);

    return BlocConsumer<SelectGroupCubit, SelectGroupState>(
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            context.tr("select_group_title"),
            style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800),
          ),
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          actions: [
            IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: () {
                Navigator.of(context).pop({
                  "groupId": state.selectedGroupId,
                  "groupName": state.selectedGroupId == null
                      ? null
                      : state.selectedGroupName,
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: buildTree(context, state),
          ),
        ),
      ),
      listener: (context, state) => {},
    );
  }

  Widget buildTree(BuildContext context, SelectGroupState state) {
    try {
      return TreeView(
        nodes: toTreeNodes(context, state, state.treeMap, state.items),
        treeController: _treeController,
        indent: 24,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  List<TreeNode> toTreeNodes(
    BuildContext context,
    SelectGroupState state,
    Map<int, dynamic>? map,
    Map<int, Group>? data,
  ) {
    if (map != null)
      return map.keys
          .map(
            (k) => TreeNode(
              content: _buildGroupRow(context, state, data?[k]),
              children: toTreeNodes(context, state, map[k], data),
            ),
          )
          .toList();
    return [];
  }

  Widget _buildGroupRow(
    BuildContext context,
    SelectGroupState state,
    Group? item,
  ) {
    final theme = Theme.of(context);
    final bool isSelected = item?.id == state.selectedGroupId;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : (theme.cardTheme.color ?? theme.colorScheme.surface),
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 1.5)
              : Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.1 : 0.01),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.read<SelectGroupCubit>().select(item),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    UIConstants.groupIconData,
                    size: 20,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item?.name ?? '',
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 15,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if ((item?.description ?? '').isNotEmpty)
                          Text(
                            item!.description,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
