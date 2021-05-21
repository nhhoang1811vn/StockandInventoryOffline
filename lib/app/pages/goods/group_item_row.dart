import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:good_manager/domain/entities/group.dart';

class GroupItemRow extends StatelessWidget {
  final Group item;
  final void Function(Group item) onGroupTapped;
  final void Function(Group item) onGroupLongPressed;

  GroupItemRow(this.item, this.onGroupTapped, this.onGroupLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(item.name),
        subtitle: Text(item.description),
        //trailing: Text(item.quality.toString()),
        leading: Icon(Icons.folder),
        onTap: () => onGroupTapped(item),
        onLongPress: () => onGroupLongPressed(item));
  }
}
