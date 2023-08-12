import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/presentation/main.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:sprintf/sprintf.dart';
import '../../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ReportDetailPage extends StatelessWidget {
  final ReportType type;
  final DateTime start;
  final DateTime end;
  ReportDetailPage(this.type, this.start, this.end);

  @override
  Widget build(BuildContext context) {
    context.read<ReportDetailCubit>().init(context,type, start, end);

    return BlocConsumer<ReportDetailCubit, ReportDetailState>(
        builder: (context, state) => Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, state)),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {});
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(title: new Text(type.getTitle(context)),
      actions: [_buildExportExcelFileMenu(context)],),
    );
  }
  Widget _buildExportExcelFileMenu(BuildContext context){
    return InkWell(
      onTap: () => context.read<ReportDetailCubit>().onExportExcelFileMenuClicked(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(FontAwesomeIcons.fileExport),
      ),
    );
  }

  Widget _buildBody(BuildContext context,ReportDetailState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        Text(sprintf(AppLocalizations.of(context)!.report_detail_header, [Config.dateFormat.format(state.start!),Config.dateFormat.format(state.end!), storage.getSelectedStoreName()])),
        SizedBox(height: 16,),
        Table(
        border: TableBorder.all(width: 1.0),
        children: state.data.map((item) {
          return TableRow(
              children: item.map((row) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      row.toString(),
                    ),
                  ),
                );
              }).toList());
        }).toList(),
      )]),
    );
  }
}
