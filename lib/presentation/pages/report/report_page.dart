import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/report_date_range_type.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../pages.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReportPageState();
  }
}

class ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
      builder: (context, state) =>
          Scaffold(appBar: _buildAppBar(context), body: _buildBody2()),
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {},
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child:
          AppBar(title: new Text(context.tr("report_title"))),
    );
  }

  Widget _buildBody2() {
    return ListView(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              for (int i = 0; i < ReportType.values.length; i++) ...[
                ListTile(
                  title: Text(ReportType.values[i].getTitle(context)),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    onReportTypeTapped(ReportType.values[i]);
                  },
                ),
                if (i < ReportType.values.length - 1) Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void onReportTypeTapped(ReportType reportType) async {
    if (reportType == ReportType.RE_ORDER) {
      onReportReorder(context);
    } else {
      ReportDateRangeType? reportDateRangeType =
          await showSelectDateRangeType(context);
      if (reportDateRangeType != null) {
        DateTime? mStart;
        DateTime? mEnd;
        DateTime now = DateTime.now();
        DateTime tmr = DateTime(now.year, now.month, now.day + 1);
        if (reportDateRangeType == ReportDateRangeType.CUSTOM) {
          DateTimeRange? range = await pickDateRange();
          if (range != null) {
            mStart = range.start;
            mEnd = range.end;
          }
        } else {
          switch (reportDateRangeType) {
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
            default:
              ;
          }
        }
        if (mStart != null && mEnd != null) {
          Navigator.of(context).pushNamed(
            Pages.report_detail,
            arguments: {'type': reportType, 'start': mStart, 'end': mEnd},
          );
        }
      }
    }
  }

  void onReportReorder(BuildContext context) async {
    Navigator.of(context).pushNamed(
      Pages.report_detail,
      arguments: {
        'type': ReportType.RE_ORDER,
      },
    );
  }

  Future<ReportDateRangeType?> showSelectDateRangeType(
    BuildContext context,
  ) async {
    return await showModalBottomSheet<ReportDateRangeType>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                context.tr("select_date_range"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Column(
              children: ReportDateRangeType.values
                  .map(
                    (type) => ListTile(
                      title: Text(type.getText(context)),
                      onTap: () => Navigator.pop(context, type),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Future<DateTimeRange?> pickDateRange() async {
    DateTimeRange dateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    return result;
    if (result != null) {
      setState(() {
        dateRange = result;
      });
    }
  }
}
