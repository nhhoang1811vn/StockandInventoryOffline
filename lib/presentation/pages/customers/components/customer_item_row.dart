import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/entity.dart';
import '../../../widget/entity_avatar.dart';

enum CustomerItemMenu { sendEmail, sendSMS, phoneCall }

class CustomerItemRow extends StatelessWidget {
  final Customer item;
  final Function(Customer) onPressed;
  final Function(Customer) onLongPressed;
  final Function(Customer) onSendEmailPressed;
  final Function(Customer) onSendSmsPressed;
  final Function(Customer) onPhoneCallPressed;

  CustomerItemRow(this.item,
      this.onPressed,
      this.onLongPressed,
      this.onSendEmailPressed,
      this.onSendSmsPressed,
      this.onPhoneCallPressed,);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(item),
          onLongPress: () => onLongPressed(item),
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                EntityAvatar(
                  file: item.file,
                  name: item.name,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (item.numberDocument > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          "${item.numberDocument} ${context.tr("documents")}",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<CustomerItemMenu>(
                  onSelected: (CustomerItemMenu result) {
                    switch (result) {
                      case CustomerItemMenu.sendEmail:
                        onSendEmailPressed(item);
                        break;
                      case CustomerItemMenu.sendSMS:
                        onSendSmsPressed(item);
                        break;
                      default:
                        onPhoneCallPressed(item);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext a) =>
                      <PopupMenuEntry<CustomerItemMenu>>[
                    PopupMenuItem<CustomerItemMenu>(
                      value: CustomerItemMenu.sendEmail,
                      child: Text(context.tr("send_email")),
                    ),
                    PopupMenuItem<CustomerItemMenu>(
                      value: CustomerItemMenu.sendSMS,
                      child: Text(context.tr("send_sms")),
                    ),
                    PopupMenuItem<CustomerItemMenu>(
                      value: CustomerItemMenu.phoneCall,
                      child: Text(context.tr("phone_call")),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
