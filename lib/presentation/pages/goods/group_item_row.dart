import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/presentation/constants.dart';

class GroupItemRow extends StatelessWidget {
  final Group item;
  final void Function(Group item) onGroupTapped;
  final void Function(Group item) onGroupLongPressed;

  GroupItemRow(this.item, this.onGroupTapped, this.onGroupLongPressed);

  @override
  Widget build(BuildContext context) {
    TextStyle? primaryTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    TextStyle? secondaryTextStyle = Theme.of(context).textTheme.bodySmall;
    return InkWell(
      //borderRadius: BorderRadius.circular(8),
      onTap: () => onGroupTapped(item),
      onLongPress: () => onGroupLongPressed(item),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(UIConstants.groupIconData, size: 36, color: Theme.of(context).colorScheme.primary),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: primaryTextStyle),
                Visibility(
                  visible: item.description.isNotEmpty,
                  child: Text(
                    item.description,
                    style: secondaryTextStyle,
                  ),
                ),
                if (item.barCode != null && item.barCode!.isNotEmpty)
                  Row(children: [
                    Icon(UIConstants.barcodeIconData, size: 24, color: Theme.of(context).colorScheme.primary),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      item.barCode!,
                      style: secondaryTextStyle,
                    )
                  ])
              ],
            )
          ],
        ),
      ),
    );
  }
}
