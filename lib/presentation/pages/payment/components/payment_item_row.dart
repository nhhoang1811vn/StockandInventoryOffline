import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/style_size.dart';

import '../../../constants.dart';

class PaymentItemRow extends StatelessWidget {
  final Payment item;
  final void Function(Payment item) onPressed;
  final void Function(Payment item) onLongPressed;

  PaymentItemRow(this.item, this.onPressed, this.onLongPressed);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(Config.dateFormat.format(item.date), style: AppStyle.getTitleListTitleStyle()),
      subtitle: Text(item.description, style: AppStyle.getSubTitleListTitleStyle(),),
      trailing: Text(Config.currencyFormat.format(item.amount),
          style: AppStyle.getTrailingListTitleStyle()),
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
    );
  }
}
