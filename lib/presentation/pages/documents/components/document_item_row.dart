import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/utils.dart';

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
    TextStyle? primaryTextStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w700);
    TextStyle? secondaryTextStyle = Theme.of(context).textTheme.bodySmall;
    return Container(
      color: bgColor,
      padding: EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onDocumentTapped(item),
        onLongPress: () => onDocumentLongPressed(item),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: getIndicatorColor(item.type),
                    // Change color as needed
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    //),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: primaryTextStyle,
                          ),
                          //SizedBox(height: 4),
                          Text(
                            DateFormatFactory.getDateFormat().format(item.date),
                            style: secondaryTextStyle,
                          ),
                          item.personName != null
                              ? Text(
                                  item.personName!,
                                  style: secondaryTextStyle,
                                )
                              : Container(),
                          item.description.isNotEmpty
                              ? Text(
                                  item.description,
                                  style: secondaryTextStyle,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringUtils.getQuantityText(item.quantity),
                          style: primaryTextStyle,
                        ),
                        _buildStatusWidget(context, item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
      statusText = AppLocalizations.of(context)!.payment_status_paid;
    } else if (status == DocumentPaidStatus.unpaid) {
      bgColor = Colors.red.shade700;
      statusText = AppLocalizations.of(context)!.payment_status_unpaid;
    } else {
      bgColor = Colors.orange.shade700;
      statusText = AppLocalizations.of(context)!.payment_status_partial;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Text(
            statusText,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        if (status == DocumentPaidStatus.partial)
          Text(
            "${Config.currencyFormat.format(item.paid)}/${Config.currencyFormat.format(item.amount)}",
          )
        else
          Text("${Config.currencyFormat.format(item.amount)}"),
      ],
    );
  }
}
