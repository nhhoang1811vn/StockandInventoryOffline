import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/common/helpers/injection.container.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/components/select_date_range_dialog.dart';
import 'package:good_manager/presentation/pages/report/components/select_group_dialog.dart';
import 'package:good_manager/presentation/pages/report/report_date_range_type.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';

import '../../constants.dart';
import '../pages.dart';

class ReportPage extends StatefulWidget{
  ReportPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ReportPageState();
  }
}
class ReportPageState extends BaseStateWidget<ReportPage> {
  @override
  bool hasDrawer() {
    return true;
  }
  @override
  Widget buildWidget(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
        builder: (context, state) => Scaffold(
          key: ScaffoldKey,
            //drawer: CustomNavigationDrawer(selectedIndex: 4, storeName: storage.getSelectedStoreName()),
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
            if (type == ReportType.LIST_OF_GOODS){
              onReportListOfGood(context);
            }else{
              onReportTypeClicked(context, type);
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey[500]);
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
  void onReportListOfGood(BuildContext context) async{
    Map? result = await showSelectDateRangeDialog(context, ReportDateRangeType.CURRENT_MONTH);
    if (result != null){
      DateTime start = result["start"];
      DateTime end = result["end"];

      Map? result2 = await showSelectGroupDialog(context);
      if (result2 != null){
        int? groupId = result2["groupId"];
        String? groupName = result2["groupName"];
        Navigator.of(context).pushNamed(
            Pages.report_detail,
            arguments: {
              'type': ReportType.LIST_OF_GOODS,
              'start': start,
              'end': end,
              'groupId': groupId,
              'groupName': groupName
            });
      }
    }
  }

  Future<Map?> showSelectDateRangeDialog(BuildContext context, ReportDateRangeType type) async {
    Map? result = await showDialog(context: context, builder: (_) => SelectDateRangeDialog(type));
    return result;
  }

  Future<Map?> showSelectGroupDialog(BuildContext context) async {
    Map? result = await showDialog(context: context, builder: (_) => BlocProvider(
        create: (context) => getIt<SelectGroupCubit>(),
        child: SelectGroupDialog(
        )));
    return result;
  }
}
