import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment_status.dart';

import '../../../style_size.dart';

class SelectPaymentStatusDialog extends StatefulWidget {
  final PaymentStatus status;
  SelectPaymentStatusDialog(this.status);

  @override
  SelectPaymentStatusDialogState createState() => SelectPaymentStatusDialogState();
}

class SelectPaymentStatusDialogState extends State<SelectPaymentStatusDialog> {
  late PaymentStatus _status;
  @override
  void initState() {
    _status = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.select_payment_status),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRadioListTile(PaymentStatus.UNPAID),
                getRadioListTile(PaymentStatus.PARTIAL),
                getRadioListTile(PaymentStatus.PAID),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            Navigator.of(context).pop(_status);
          },
        )
      ]
    );
  }

  RadioListTile<PaymentStatus> getRadioListTile(PaymentStatus value) {
    return RadioListTile<PaymentStatus>(
      title: Text(value.getTitle(context), style: TextStyle(fontSize: TextSize.medium)),
      value: value,
      groupValue: _status,
      onChanged: (PaymentStatus? value) {
        setState(() {
          _status = value!;
        });
      },
      dense: true,
    );
  }
}
