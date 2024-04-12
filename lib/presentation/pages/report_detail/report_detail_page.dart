
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_to_pdf/export_delegate.dart';
import 'package:flutter_to_pdf/export_frame.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/presentation/main.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';

import '../../constants.dart';

class ReportDetailPage extends StatelessWidget {
  final ReportType type;
  final DateTime start;
  final DateTime end;

  ReportDetailPage(this.type, this.start, this.end);

  // create instance of ExportDelegate
  final ExportDelegate exportDelegate = ExportDelegate();

  @override
  Widget build(BuildContext context) {
    context.read<ReportDetailCubit>().init(context, type, start, end);

    return BlocConsumer<ReportDetailCubit, ReportDetailState>(
        builder: (context, state) => Scaffold(appBar: _buildAppBar(context, state), body:
        ExportFrame(frameId: "content",
            exportDelegate: exportDelegate,
            child: _buildBody2(context, state))),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {});
  }

  PreferredSize _buildAppBar(BuildContext context, ReportDetailState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(type.getTitle(context)),
        actions: [_buildExportExcelFileMenu(context), _buildPDFMenu(context, state)],
      ),
    );
  }

  Widget _buildExportExcelFileMenu(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<ReportDetailCubit>().onExportExcelFileMenuClicked();
        },
        icon: Icon(Icons.file_open_outlined));
  }
  Widget _buildPDFMenu(BuildContext context, ReportDetailState state) {
    return IconButton(
        onPressed: () async{
          final pdf = await exportDelegate.exportToPdfDocument('content');
          saveFile(context,pdf, 'output');
        },
        icon: Icon(Icons.picture_as_pdf));
  }
  Future<void> saveFile(context,document, String name) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/$name.pdf');

    await file.writeAsBytes(await document.save());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Saved exported PDF at: ${file.path}'),
    ));
  }

  List<Widget> _buildFirstColumn(ReportDetailState state) {
    List<Widget> results = [];
    bool flag = true;
    state.data.asMap().forEach((key, value) {
      if (key == 0 || key == state.data.length - 1) {
        results.add(_buildHighlightCell(value.first));
      } else {
        results.add(_buildNormalCell(value.first, flag));
        flag = !flag;
      }
    });
    return results;
  }

  List<Widget> _buildRows(ReportDetailState state) {
    List<Widget> results = [];
    bool flag = false;
    state.data.asMap().forEach((key, value) {
      List<Widget> rows = [];

      for (int i = 1; i < value.length; i++) {
        if (key == 0 || key == state.data.length - 1) {
          rows.add(_buildHighlightCell(value[i]));
        }else{
          rows.add(_buildNormalCell(value[i], flag));
        }
      }
      flag = !flag;
      results.add(Row(children: rows));
    });
    return results;
  }
  Widget _buildHighlightCell(String value){
    return _buildCell(value, UIConstants.primaryDarkColor, Colors.white, FontWeight.w600);
  }
  Widget _buildNormalCell(String value, bool type){
    if (type){
      return _buildNormalCellType1(value);
    }else{
      return _buildNormalCellType2(value);
    }
  }
  Widget _buildNormalCellType1(String value){
    return _buildCell(value, Colors.grey.shade200, Colors.black, FontWeight.w400);
  }
  Widget _buildNormalCellType2(String value){
    return _buildCell(value, Colors.white, Colors.black, FontWeight.w400);
  }

  Widget _buildCell(String value, Color backgroundColor, Color textColor, FontWeight fontWeight){
    return Container(
      alignment: Alignment.center,
      width: 120.0,
      height: 30.0,
      color: backgroundColor,
      margin: EdgeInsets.all(1.0),
      child: Text(
        value,
        style: TextStyle(color: textColor, fontWeight: fontWeight),
      ),
    );
  }

  Widget _buildBody2(BuildContext context, ReportDetailState state) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(

      children: [
        Text(sprintf(AppLocalizations.of(context)!.report_detail_header, [
          Config.dateFormat.format(state.start!),
          Config.dateFormat.format(state.end!),
          storage.getSelectedStoreName()
        ])),
        SizedBox(
          height: 16,
        ),
        SingleChildScrollView(

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildFirstColumn(state),
              ),
              Flexible(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildRows(state),
                      )))
            ],
          ),
        )
      ],
    ));
  }
}
