import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';

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
          style: AppStyle.getTitleListTitleStyle(),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: item.description.isNotEmpty,
              child: Text(
                item.description,
                style: AppStyle.getSubTitleListTitleStyle(),
              ),
            ),
            if (item.barCode != null)
              Row(children: [
                Icon(UIConstants.barcodeIconData, size: 24, color: UIConstants.primaryColor),
                SizedBox(
                  width: 8,
                ),
                Text(item.barCode!, style: AppStyle.getSubTitleListTitleStyle(),)
              ])
          ],
        ),
        //trailing: Text(item.quality.toString()),
        leading: Icon(UIConstants.groupIconData, size: 32, color: UIConstants.primaryColor,),
        onTap: () => onGroupTapped(item),
        onLongPress: () => onGroupLongPressed(item));
  }
}
