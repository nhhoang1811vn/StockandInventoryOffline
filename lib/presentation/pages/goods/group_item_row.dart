import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';

class GroupItemRow extends StatelessWidget {
  final Group item;
  final Function(Group) onGroupTapped;
  final Function(Group) onGroupLongPressed;

  GroupItemRow(this.item, this.onGroupTapped, this.onGroupLongPressed);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onGroupTapped(item),
        onLongPress: () => onGroupLongPressed(item),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: SizedBox(
            height: 48,
            width: 48,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                UIConstants.groupIconData,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          title: Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (item.barCode != null && item.barCode!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        UIConstants.barcodeIconData,
                        size: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.barCode!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
