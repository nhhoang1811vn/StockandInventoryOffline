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
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onGroupTapped(item),
        onLongPress: () => onGroupLongPressed(item),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(UIConstants.groupIconData, size: 32, color: Theme.of(context).colorScheme.onPrimary),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                  Visibility(
                    visible: item.description.isNotEmpty,
                    child: Text(
                      item.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  if (item.barCode != null)
                    Row(children: [
                      Icon(UIConstants.barcodeIconData, size: 24, color: UIConstants.primaryColor),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        item.barCode!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onSurface),
                      )
                    ])
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
