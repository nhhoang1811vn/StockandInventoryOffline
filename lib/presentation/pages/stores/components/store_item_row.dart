import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';

class StoreItemRow extends StatelessWidget {
  final Store item;
  final int? selectedStoreId;
  final bool isSelection;
  //final StoreRole? role;
  final Function(Store) onPressed;
  final Function(Store) onLongPressed;
  //final Function(Store) onInviteStore;

  StoreItemRow(
      this.item,
      this.selectedStoreId,
      this.isSelection,
      //this.role,
      this.onPressed,
      this.onLongPressed,
      //this.onInviteStore,
      );

  @override
  Widget build(BuildContext context) {
    final bool isSelected = isSelection && item.id == selectedStoreId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              UIConstants.storeIconData,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
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
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (item.networkId.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    item.networkId,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
          trailing: (isSelected ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null),
        ),
      ),
    );
  }
}
