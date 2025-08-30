import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';

import '../../../../domain/entity/entity.dart';

enum SupplierItemMenu { sendEmail, sendSMS, phoneCall }

class CustomerItemRow extends StatelessWidget {
  final Customer item;
  final Function(Customer) onPressed;
  final Function(Customer) onLongPressed;
  final Function(Customer) onSendEmailPressed;
  final Function(Customer) onSendSmsPressed;
  final Function(Customer) onPhoneCallPressed;

  CustomerItemRow(
    this.item,
    this.onPressed,
    this.onLongPressed,
    this.onSendEmailPressed,
    this.onSendSmsPressed,
    this.onPhoneCallPressed,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(item),
      onLongPress: () => onLongPressed(item),
      //borderRadius: BorderRadius.circular(8),
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
            item.numberDocument > 0
                ? Text(
                    item.numberDocument.toString() +
                        " " +
                        AppLocalizations.of(context)!.documents_title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  )
                : Container(),
          ],
        ),
        trailing: PopupMenuButton<SupplierItemMenu>(
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
          itemBuilder: (BuildContext a) => <PopupMenuEntry<SupplierItemMenu>>[
            PopupMenuItem<SupplierItemMenu>(
              value: SupplierItemMenu.sendEmail,
              child: Text(AppLocalizations.of(context)!.action_send_email),
            ),
            PopupMenuItem<SupplierItemMenu>(
              value: SupplierItemMenu.sendSMS,
              child: Text(AppLocalizations.of(context)!.action_send_sms),
            ),
            PopupMenuItem<SupplierItemMenu>(
              value: SupplierItemMenu.phoneCall,
              child: Text(AppLocalizations.of(context)!.action_phone_call),
            ),
          ],
        ),
      ),
    );
  }
}
