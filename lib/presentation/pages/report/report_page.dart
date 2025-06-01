import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/components/select_date_range_dialog.dart';
import 'package:good_manager/presentation/pages/report/report_date_range_type.dart';

import '../../constants.dart';
import '../pages.dart';

class ReportPage extends StatefulWidget{
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
        builder: (context, state) => Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody()),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {});
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(title: new Text(AppLocalizations.of(context)!.report_title)),
    );
  }

  Widget _buildBody() {
    return ListView.separated(
      itemCount: ReportType.values.length,
      itemBuilder: (BuildContext context, int index) {
        ReportType type = ReportType.values[index];
        return ListTile(

          title: Text(
            type.getTitle(context),
          ),
          onTap: () {
            if (type == ReportType.RE_ORDER){
              onReportReorder(context);
            }else{
              onReportTypeClicked(context, type);
            }
          },
            trailing: Icon(Icons.navigate_next),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1,);
      },
    );
  }
  void onReportTypeClicked(BuildContext context, ReportType reportType) async{
    Map? result = await showSelectDateRangeDialog(context, ReportDateRangeType.CURRENT_MONTH);
    if (result != null){
      DateTime start = result["start"];
      DateTime end = result["end"];
      Navigator.of(context).pushNamed(Pages.report_detail, arguments: {'type': reportType, 'start': start, 'end': end});
    }
  }
  void onReportReorder(BuildContext context) async{
    Navigator.of(context).pushNamed(
        Pages.report_detail,
        arguments: {
          'type': ReportType.RE_ORDER,
        });
  }

  Future<Map?> showSelectDateRangeDialog(BuildContext context, ReportDateRangeType type) async {
    Map? result = await showDialog(context: context, builder: (_) => SelectDateRangeDialog(type));
    return result;
  }
}
