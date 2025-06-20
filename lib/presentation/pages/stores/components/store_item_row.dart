import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';

class StoreItemRow extends StatelessWidget{
  final Store item;
  final void Function(Store item) onPressed;
  final void Function(Store item) onLongPressed;
  final bool isSelection;
  StoreItemRow(this.item, this.onPressed, this.onLongPressed, this.isSelection);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelection && item.id == storage.getSelectedStoreId() ? Colors.blue[50] : null,
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        child: ListTile(
          //tileColor: isSelection && item.id == storage.getSelectedStoreId() ? Colors.blue[50] : null,
          leading: Icon(UIConstants.storeIconData, size: 24,color: Theme.of(context).colorScheme.primary),
          title: Text(item.name, style:
              Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.description.isNotEmpty
                  ? Text(item.description,style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onSurface),)
                  : Container(),
            ],
          )
        ),
      ),
    );
  }
}