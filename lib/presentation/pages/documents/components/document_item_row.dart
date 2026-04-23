import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/util/currency_formatter.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../util/util.dart';

class DocumentItemRow extends StatelessWidget {
  final Document item;
  final Color bgColor;
  final Color? incomingColor;
  final Color? outgoingColor;
  final Function(Document document) onDocumentTapped;
  final Function(Document document) onDocumentLongPressed;

  DocumentItemRow({
    required this.item,
    required this.bgColor,
    required this.incomingColor,
    required this.outgoingColor,
    required this.onDocumentTapped,
    required this.onDocumentLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onDocumentTapped(item),
        onLongPress: () => onDocumentLongPressed(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: getIndicatorColor(item.type),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormatFactory.getDateFormat().format(item.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (item.personName != null)
                        Text(
                          item.personName!,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      if (item.description.isNotEmpty)
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringUtils.getQuantityText(item.quantity),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusWidget(context, item),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? getIndicatorColor(DocumentType type) {
    switch (type) {
      case DocumentType.incoming:
        return incomingColor;
      default:
        return outgoingColor;
    }
  }

  Widget _buildStatusWidget(BuildContext context, Document item) {
    var bgColor;
    var statusText = "";
    var status = Utils.getStatus(item);
    if (status == DocumentPaidStatus.paid) {
      bgColor = Colors.green.shade700;
      statusText = context.tr("payment_status_paid");
    } else if (status == DocumentPaidStatus.unpaid) {
      bgColor = Colors.red.shade700;
      statusText = context.tr("payment_status_unpaid");
    } else {
      bgColor = Colors.orange.shade700;
      statusText = context.tr("payment_status_partial");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            statusText,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (status == DocumentPaidStatus.partial)
          Text(
            "${CurrencyFormatter.format(context, item.paid)}/${CurrencyFormatter.format(context, item.amount)}",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        else
          Text(
            CurrencyFormatter.format(context, item.amount),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
