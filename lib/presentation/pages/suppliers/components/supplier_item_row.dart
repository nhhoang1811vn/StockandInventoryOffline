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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onPressed(item),
        onLongPress: () => onLongPressed(item),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
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
              if (item.numberDocument > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "${item.numberDocument} ${context.tr("documents")}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
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
          ),
        ),
      ),
    );
  }
}
