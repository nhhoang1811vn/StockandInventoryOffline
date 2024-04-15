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

  DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    _type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
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
                ],
                if (_type == ReportDateRangeType.CUSTOM)
                  ...[
                  Divider(color: Colors.grey),
                  Row(children: [
                    Expanded(child: ElevatedButton(child: Text('${start
                        .day}/${start.month}/${start.year}'),
                        onPressed: pickDateRange)),
                    SizedBox(width: 8.0,),
                    Expanded(child: ElevatedButton(child: Text('${end.day}/${end
                        .month}/${end.year}'), onPressed: pickDateRange)),
                  ],)
                ]
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
    TextButton(
    child: Text(AppLocalizations.of(context)!.action_cancel),
    onPressed: (){
      Navigator.of(context).pop();
    },
    ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            var result = Map();
            //result["type"] =  _type;
            DateTime mStart;
            DateTime mEnd;
            DateTime now = DateTime.now();
            DateTime tmr = DateTime(now.year, now.month, now.day + 1);

            switch(_type){
              case ReportDateRangeType.CURRENT_MONTH:
                mStart = DateTime(now.year, now.month, 1);
                mEnd = DateTime(now.year, now.month + 1, 0);
                break;
              case ReportDateRangeType.LAST_30_DAYS:
                mStart = DateTime(now.year, now.month, now.day - 30);
                mEnd = tmr.subtract(Duration(seconds: 1));
                break;
              case ReportDateRangeType.LAST_90_DAYS:
                mStart = DateTime(now.year, now.month, now.day - 90);
                mEnd = tmr.subtract(Duration(seconds: 1));
                break;
              case ReportDateRangeType.CURRENT_YEAR:
                mStart = DateTime(now.year, 1, 1);
                mEnd = DateTime(now.year, 12, 31);
                break;
              case ReportDateRangeType.CUSTOM:
                mStart = start;
                mEnd = end;
            }
            result["start"] = mStart;
            result["end"] = mEnd;
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
  Future pickDateRange() async{
    DateTimeRange? result = await showDateRangePicker(context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (result != null){
      setState(() {
        dateRange = result;
      });
    }
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
