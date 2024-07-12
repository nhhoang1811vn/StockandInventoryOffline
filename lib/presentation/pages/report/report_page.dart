import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/components/select_date_range_dialog.dart';
import 'package:good_manager/presentation/pages/report/report_date_range_type.dart';

import '../../../main.dart';
import '../../constants.dart';
import '../custom_navigation_drawer.dart';
import '../pages.dart';


class ReportPage extends StatelessWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
        builder: (context, state) => Scaffold(
            drawer: CustomNavigationDrawer(selectedIndex: 4, storeName: storage.getSelectedStoreName()),
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
          visualDensity: VisualDensity(vertical: -3), // to compact
          title: Text(
            type.getTitle(context),
          ),
          onTap: () {
            onReportTypeClicked(context, type);
          },
          /*trailing: PopupMenuButton<ExportType>(
              onSelected: (ExportType result) {},
              itemBuilder: (BuildContext a) => <PopupMenuEntry<ExportType>>[
                    PopupMenuItem<ExportType>(
                        value: ExportType.TO_EXCEL, child: Text(AppLocalizations.of(context)!.action_send_email)),
                    PopupMenuItem<ExportType>(
                        value: ExportType.TO_PDF, child: Text(AppLocalizations.of(context)!.action_send_email)),
                  ]),*/
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey[500]);
      },
    );
  }
  void onReportTypeClicked(BuildContext context, ReportType reportType) async{
    Map? result = await showSelectDateRangeDialog(context, ReportDateRangeType.CURRENT_MONTH);
    if (result == null){

    }else{
      DateTime start = result["start"];
      DateTime end = result["end"];
      Navigator.of(context).pushNamed(Pages.report_detail, arguments: {'type': reportType, 'start': start, 'end': end});
    }
  }

  Future<Map?> showSelectDateRangeDialog(BuildContext context, ReportDateRangeType type) async {
    Map? result = await showDialog(context: context, builder: (_) => SelectDateRangeDialog(type), barrierDismissible: false);
    return result;
  }
}
