import 'package:good_manager/util/dimen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../../widget/entity_avatar.dart';

enum SupplierItemMenu { sendEmail, sendSMS, phoneCall }

class SupplierItemRow extends StatelessWidget {
  final Supplier item;
  final Function(Supplier) onPressed;
  final Function(Supplier) onLongPressed;
  final Function(Supplier) onSendEmailPressed;
  final Function(Supplier) onSendSmsPressed;
  final Function(Supplier) onPhoneCallPressed;

  SupplierItemRow(this.item, {
    required this.onPressed,
    required this.onLongPressed,
    required this.onSendEmailPressed,
    required this.onSendSmsPressed,
    required this.onPhoneCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.screenPadding, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.015),
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
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.cardPadding),
            child: Row(
              children: [
                EntityAvatar(
                  file: item.file,
                  name: item.name,
                  radius: Dimens.tileSize / 2,
                  fallbackIcon: UIConstants.supplierIconData,
                ),
                const SizedBox(width: Dimens.tileGap),
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
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
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
                PopupMenuButton<SupplierItemMenu>(
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
                  itemBuilder: (BuildContext a) =>
                      <PopupMenuEntry<SupplierItemMenu>>[
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
