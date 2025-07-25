/*
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/l10n/app_localizations.dart';

class AddPaymentDialog extends StatefulWidget {
  @override
  State createState() => AddPaymentDialogState();
}
class AddPaymentDialogState extends State<AddPaymentDialog> {
  PaymentType _type = PaymentType.inbound;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.notification_dialog_title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                getRadioListTile(
                    AppLocalizations.of(context)!.title_inbound_payment,
                    PaymentType.inbound),
                getRadioListTile(
                    AppLocalizations.of(context)!.title_outbound_payment,
                    PaymentType.outbound),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            Navigator.of(context).pop(_type);
          },
        ),
      ],
    );
  }

  RadioListTile<PaymentType> getRadioListTile(
      String text, PaymentType value) {
    return RadioListTile<PaymentType>(
      title: Text(text),
      value: value,
      groupValue: _type,
      onChanged: (PaymentType? value) {
        setState(() {
          _type = value!;
        });
      },
    );
  }
}
*/
