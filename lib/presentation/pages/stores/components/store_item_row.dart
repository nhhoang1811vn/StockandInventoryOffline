import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';

class StoreItemRow extends StatelessWidget {
  final Store item;
  final int selectedStoreId;
  final bool isSelection;
  final Function(Store) onPressed;
  final Function(Store) onLongPressed;

  StoreItemRow(
    this.item,
    this.selectedStoreId,
    this.isSelection,
    this.onPressed,
    this.onLongPressed,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelection && item.id == selectedStoreId ? Colors.blue[50] : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        child: ListTile(
          leading: Icon(
            UIConstants.storeIconData,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            item.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.description.isNotEmpty
                  ? Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    )
                  : Container(),
              item.networkId.isNotEmpty ? Text(item.networkId) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
