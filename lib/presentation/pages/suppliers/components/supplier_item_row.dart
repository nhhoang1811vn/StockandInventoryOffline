import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/entity.dart';

enum SupplierItemMenu { sendEmail, sendSMS, phoneCall }

class SupplierItemRow extends StatelessWidget {
  final Supplier item;
  final Function(Supplier) onPressed;
  final Function(Supplier) onLongPressed;
  final Function(Supplier) onSendEmailPressed;
  final Function(Supplier) onSendSmsPressed;
  final Function(Supplier) onPhoneCallPressed;

  SupplierItemRow(
    this.item, {
    required this.onPressed,
    required this.onLongPressed,
    required this.onSendEmailPressed,
    required this.onSendSmsPressed,
    required this.onPhoneCallPressed,
  });

  Widget trailingWidget() {
    return PopupMenuButton<SupplierItemMenu>(
      onSelected: (SupplierItemMenu result) {
        switch (result) {
          case SupplierItemMenu.sendEmail:
            onSendEmailPressed(item);
            break;
          case SupplierItemMenu.sendSMS:
            onSendSmsPressed(item);
            break;
          default:
            onPhoneCallPressed(item);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SupplierItemMenu>>[
        PopupMenuItem<SupplierItemMenu>(
          value: SupplierItemMenu.sendEmail,
          child: Text(context.tr("send_email")),
        ),
        PopupMenuItem<SupplierItemMenu>(
          value: SupplierItemMenu.sendSMS,
          child: Text(context.tr("send_sms")),
        ),
        PopupMenuItem<SupplierItemMenu>(
          value: SupplierItemMenu.phoneCall,
          child: Text(context.tr("phone_call")),
        ),
      ],
    );
  }

  Widget subtitleWidget(BuildContext context) {
    return Column(
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
        item.numberDocument > 0
            ? Text(
                item.numberDocument.toString() +
                    " " +
                    context.tr("documents"),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${item.name[0].toUpperCase()}'),
        ),
        title: Text(
          item.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        subtitle: subtitleWidget(context),
        trailing: trailingWidget(),
      ),
    );
  }
}
