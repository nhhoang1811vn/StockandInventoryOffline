import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/constants.dart';

class StoreItemRow extends StatelessWidget{
  final Store item;
  final void Function(Store item) onPressed;
  final void Function(Store item) onLongPressed;
  StoreItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(UIConstants.storeIconData, size: 24,color: AppColors.primaryColor,),
      title: Text(item.name, style:
          Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.description.isNotEmpty
              ? Text(item.description,style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground),)
              : Container(),
        ],
      ),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
}