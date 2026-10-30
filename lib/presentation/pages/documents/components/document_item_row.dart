import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widget/entity_avatar.dart';
import 'package:good_manager/util/currency_formatter.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../util/util.dart';

class DocumentItemRow extends StatelessWidget {
  final Document item;
  final Color bgColor;
  final Color incomingColor;
  final Color outgoingColor;
  final Function(Document document) onDocumentTapped;
  final Function(Document document) onDocumentLongPressed;
  final bool showTimeOnly;
  final EdgeInsets margin;

  const DocumentItemRow({
    super.key,
    required this.item,
    required this.bgColor,
    required this.incomingColor,
    required this.outgoingColor,
    required this.onDocumentTapped,
    required this.onDocumentLongPressed,
    this.showTimeOnly = false,
    this.margin = const EdgeInsets.symmetric(vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final color =
        item.type == DocumentType.incoming ? incomingColor : outgoingColor;
    final leadingIcon = item.type == DocumentType.incoming
        ? Icons.file_download_outlined
        : Icons.file_upload_outlined;
    final status = Utils.getStatus(item);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onDocumentTapped(item),
          onLongPress: () => onDocumentLongPressed(item),
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Dimens.tileSize,
                  height: Dimens.tileSize,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimens.tileRadius),
                  ),
                  child: Icon(
                    leadingIcon,
                    color: color,
                    size: Dimens.tileIconSize,
                  ),
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
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.45),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      if (item.personName != null) ...[
                        Row(
                          children: [
                            EntityAvatar(
                              file: item.personFile,
                              name: item.personName ?? '',
                              radius: 10,
                              fallbackIcon: item.type == DocumentType.incoming
                                  ? UIConstants.supplierIconData
                                  : UIConstants.customerIconData,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.personName!,
                                style: const TextStyle(
                                  color: Color(0xFF8E9199),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        showTimeOnly
                            ? DateFormatFactory.getTimeFormat()
                                .format(item.date)
                            : DateFormatFactory.getDateAndTimeFormat()
                                .format(item.date),
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.2),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStatusBadge(context, status),
                    const SizedBox(height: 4),
                    Text(
                      StringUtils.getQuantityText(item.quantity),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.format(context, item.amount),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: color,
                      ),
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

  Widget _buildStatusBadge(BuildContext context, DocumentPaidStatus status) {
    Color color;
    String text;

    switch (status) {
      case DocumentPaidStatus.paid:
        color = Colors.green;
        text = context.tr("payment_status_paid");
        break;
      case DocumentPaidStatus.unpaid:
        color = Colors.red;
        text = context.tr("payment_status_unpaid");
        break;
      case DocumentPaidStatus.partial:
        color = Colors.orange;
        text = context.tr("payment_status_partial");
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
