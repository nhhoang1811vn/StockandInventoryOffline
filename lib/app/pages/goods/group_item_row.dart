import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/group.dart';

class GroupItemRow extends StatelessWidget {
  final Group item;
  final void Function(Group item) onGroupTapped;
  final void Function(Group item) onGroupLongPressed;

  GroupItemRow(this.item, this.onGroupTapped, this.onGroupLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          item.name,
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: item.description.isNotEmpty,
              child: Text(
                item.description,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Visibility(
                visible: item.barCode.isNotEmpty,
                child: Row(children: [
                  Image.asset(
                    UIConstants.barcodeIconPath,
                    width: 24,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(item.barCode, style: TextStyle(fontSize: 14))
                ]))
          ],
        ),
        //trailing: Text(item.quality.toString()),
        leading: Image.asset(
          UIConstants.folderIconPath,
          width: 24,
        ),
        onTap: () => onGroupTapped(item),
        onLongPress: () => onGroupLongPressed(item));
  }
}
