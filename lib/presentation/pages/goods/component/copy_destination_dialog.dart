import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/entity.dart';
import '../../pages.dart';

/// Lets the user choose the Store and (parent) Group of a copied Good or Group.
/// Pops `{"storeId": int, "groupId": int?}` on OK and null on Cancel.
class CopyDestinationDialog extends StatefulWidget {
  final List<Store> stores;
  final int initialStoreId;
  final int? initialGroupId;
  final String? initialGroupName;

  const CopyDestinationDialog({
    super.key,
    required this.stores,
    required this.initialStoreId,
    required this.initialGroupId,
    required this.initialGroupName,
  });

  @override
  State<CopyDestinationDialog> createState() => _CopyDestinationDialogState();
}

class _CopyDestinationDialogState extends State<CopyDestinationDialog> {
  late int _storeId = widget.initialStoreId;
  late int? _groupId = widget.initialGroupId;
  late String? _groupName = widget.initialGroupName;

  void _onStoreChanged(int? value) {
    if (value == null || value == _storeId) return;
    setState(() {
      _storeId = value;
      _groupId = null;
      _groupName = null;
    });
  }

  Future<void> _pickGroup() async {
    final result = await Navigator.of(context).pushNamed(
      Pages.select_group,
      arguments: {"id": null, "groupId": _groupId, "storeId": _storeId},
    );
    if (result == null || !mounted) return;
    final map = result as Map<dynamic, dynamic>;
    setState(() {
      _groupId = map["groupId"];
      _groupName = map["groupName"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storeIds = widget.stores.map((s) => s.id).toList();
    return AlertDialog(
      title: Text(context.tr("action_copy")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<int>(
            initialValue: storeIds.contains(_storeId) ? _storeId : null,
            isExpanded: true,
            decoration: InputDecoration(labelText: context.tr("select_store")),
            items: widget.stores
                .map((s) => DropdownMenuItem<int>(
                      value: s.id,
                      child: Text(s.name, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: _onStoreChanged,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickGroup,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: context.tr("group"),
                suffixIcon: const Icon(Icons.chevron_right),
              ),
              child: Text(
                _groupName ?? context.tr("no_group"),
                style: theme.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr("cancel")),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop({"storeId": _storeId, "groupId": _groupId}),
          child: Text(context.tr("ok")),
        ),
      ],
    );
  }
}
