import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/constants.dart';

import '../../../app_style.dart';

class StoreItemRow extends StatelessWidget{
  final Store item;
  final void Function(Store item) onPressed;
  final void Function(Store item) onLongPressed;
  StoreItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(UIConstants.storeIconData, size: 24,color: AppColors.primaryColor,),
      title: Text(item.name, style: AppStyle.getTitleListTitleStyle()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.description.isNotEmpty
              ? Text(item.description,style: AppStyle.getSubTitleListTitleStyle(),)
              : Container(),
        ],
      ),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
}