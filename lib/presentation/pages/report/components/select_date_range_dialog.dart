import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/report/report_date_range_type.dart';

import '../../../style_size.dart';

class SelectDateRangeDialog extends StatefulWidget {
  final ReportDateRangeType type;

  SelectDateRangeDialog(this.type);

  @override
  SelectDateRangeDialogState createState() => SelectDateRangeDialogState();
}

class SelectDateRangeDialogState extends State<SelectDateRangeDialog> {
  late ReportDateRangeType _type;

  @override
  void initState() {
    _type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.notification_dialog_title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.select_date_range),
                Divider(color: Colors.grey),
                for (var type in ReportDateRangeType.values)...[
                  getRadioListTileDateRange(type)
                ]
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

  RadioListTile<ReportDateRangeType> getRadioListTileDateRange(ReportDateRangeType value) {
    return RadioListTile<ReportDateRangeType>(
      title: Text(value.getText(context), style: TextStyle(fontSize: TextSize.medium)),
      value: value,
      groupValue: _type,
      onChanged: (ReportDateRangeType? value) {
        setState(() {
          _type = value!;
        });
      },
      dense: true,
    );
  }
}
