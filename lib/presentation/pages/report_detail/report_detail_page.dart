import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sprintf/sprintf.dart';

import '../../constants.dart';
import 'components/field_display_dialog.dart';

class ReportDetailPage extends StatefulWidget{
  final ReportType type;
  final DateTime start;
  final DateTime end;

  final int? groupId;
  final String? groupName;

  ReportDetailPage(
      this.type,
      this.start,
      this.end,
      this.groupId,
      this.groupName);
  @override
  State<StatefulWidget> createState() {
    return ReportDetailPageState();
  }
}
class ReportDetailPageState extends BaseStateWidget<ReportDetailPage> {
  static const double MIN_WIDTH_CELL = 120.0;
  @override
  Widget buildWidget(BuildContext context) {
    context.read<ReportDetailCubit>().init(
        context,
        widget.type,
        widget.start,
        widget.end,
        widget.groupId,
        widget.groupName
    );
    return BlocConsumer<ReportDetailCubit, ReportDetailState>(
        builder: (context, state) => Stack(children: [
          Scaffold(
              appBar: _buildAppBar(context, state),
              body: _buildBody(context, state)),
        ],),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {
        });
  }
  _buildBody(BuildContext context, ReportDetailState state){
    if (state.state is LoadingState)
      return _buildLoading();
    return _buildContent(context, state);
  }
  _buildLoading(){
    return Container(
      color: Colors.black.withValues(alpha: 125), // Semi-transparent background
      child: Center(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(AppLocalizations.of(context)!.loading_data, style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.none, )),
      ],
    )));
  }

  PreferredSize _buildAppBar(BuildContext context, ReportDetailState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(widget.type.getTitle(context)),
        actions: [_buildExportExcelFileMenu(context, state), _buildPDFMenu(context, state)],
      ),
    );
  }
  Widget _buildExportExcelFileMenu(BuildContext context, ReportDetailState state) {
    return IconButton(
        onPressed: () async{
          String fileName = '${getExportPdfFileName(context, state)}.csv';
          if (Platform.isWindows) {
            String? outputFile = await FilePicker.platform.saveFile(
                dialogTitle: 'Please select an output file:',
                fileName: fileName,
                allowedExtensions: ["csv"]
            );
            if (outputFile != null) {
              await saveCSVFile(context, state, outputFile);
            }
          }else{
            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
            if (selectedDirectory != null) {

              String outputFile = "$selectedDirectory/$fileName";
              await saveCSVFile(context, state, outputFile);
            }
          }
        },
        icon: FaIcon(FontAwesomeIcons.fileCsv));
  }
  Future<void> saveCSVFile(BuildContext context, ReportDetailState state, String outputFile) async{
    try{
      String csv = const ListToCsvConverter().convert(state.data);
      File file = File(outputFile);
      await file.writeAsString(csv);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lưu tệp CSV tại: ${file.path}'),
      ));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lưu tệp CSV lỗi ${e.toString()}'),
      ));
    }
  }
  Future<void> savePDFFile(BuildContext context, ReportDetailState state, String outputFile) async{
    try{
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.robotoRegular();
      pdf.addPage(pw.Page(build: (pw.Context pwContext) => _buildPDFContent(context,state, font)));
      final File file = File(outputFile);
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Lưu tệp PDF tại: ${file.path}'),
      ));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lưu tệp PDF lỗi ${e.toString()}'),
      ));
    }
  }
  Widget _buildPDFMenu(BuildContext context, ReportDetailState state) {
    return IconButton(
        onPressed: () async {
          String fileName = '${getExportPdfFileName(context, state)}.pdf';
          if (Platform.isWindows) {
            String? outputFile = await FilePicker.platform.saveFile(
                dialogTitle: 'Please select an output file:',
                fileName: fileName,
                allowedExtensions: ["pdf"]
            );

            if (outputFile != null) {
              await savePDFFile(context, state, outputFile);
            }
          }else{
            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
            if (selectedDirectory != null) {
              String outputFile = "$selectedDirectory/$fileName";
              await savePDFFile(context, state, outputFile);
            }
          }
        },
        icon: FaIcon(FontAwesomeIcons.filePdf));
  }
  String getExportPdfFileName(BuildContext context,ReportDetailState state){
    String name = state.type!.getTitle(context).replaceAll(" ", "");
    return name;
  }

  pw.Widget _buildPDFContent(BuildContext context,ReportDetailState state, pw.Font font) {
    return pw.Column(children: [
      pw.Text(sprintf(AppLocalizations.of(context)!.report_detail_header, [
        DateFormatFactory.getDateFormat().format(state.start!),
        DateFormatFactory.getDateFormat().format(state.end!),
        storage.getSelectedStoreName()
      ]), style: pw.TextStyle(font: font)),
      pw.SizedBox(height: 16.0),
      pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            ...List.generate(
                state.data.length,
                (indexI) => pw.TableRow(
                        decoration: pw.BoxDecoration(color: indexI == 0 ? PdfColors.blue : PdfColors.white),
                        children: [
                          ...List.generate(
                              state.data[indexI].length,
                              (indexJ) => pw.Padding(
                                  padding: pw.EdgeInsets.all(8.0),
                                  child: pw.Text(state.data[indexI][indexJ], style: pw.TextStyle(font: font, color: indexI == 0 ? PdfColors.white : PdfColors.black))))
                        ]))
          ])
    ]);
  }

  List<Widget> _buildFirstColumn(BuildContext context,ReportDetailState state) {
    List<Widget> results = [];
    bool flag = true;

    int columnCount = state.data.firstOrNull?.length ?? 1;
    double cellWidth = getCellWidth(context, columnCount);
    state.data.asMap().forEach((key, value) {
      if (key == 0 || key == state.data.length - 1) {
        results.add(_buildHighlightCell(value: value.first, width: cellWidth));
      } else {
        results.add(_buildNormalCell(
            value: value.first,
            width: cellWidth,
            type: flag, onPressed: (){
          if (state.type == ReportType.LIST_OF_GOODS){
            var goodId = state.ids[key - 1];
            Navigator.of(context).pushNamed(Pages.good_history, arguments: {'goodId': goodId, 'start': widget.start, 'end': widget.end});
            context.read<ReportDetailCubit>().init(context, widget.type, widget.start, widget.end, widget.groupId, widget.groupName);
          }else if (state.type == ReportType.LIST_OF_DOCUMENT || state.type == ReportType.DEBTS_BY_CUSTOMER || state.type == ReportType.DEBTS_BY_SUPPLIER){
            var item = state.documents[key -1];
            Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
            context.read<ReportDetailCubit>().init(context, widget.type, widget.start, widget.end, widget.groupId, widget.groupName);
          }
           }));
        flag = !flag;
      }
    });
    return results;
  }

  List<Widget> _buildRows(BuildContext context, ReportDetailState state) {
    List<Widget> results = [];
    bool flag = false;
    int columnCount = state.data.firstOrNull?.length ?? 1;
    double cellWidth = getCellWidth(context, columnCount);
    state.data.asMap().forEach((key, value) {
      List<Widget> rows = [];
      for (int i = 1; i < value.length; i++) {
        if (key == 0 || key == state.data.length - 1) {
          rows.add(_buildHighlightCell(value: value[i], width: cellWidth));
        } else {
          rows.add(_buildNormalCell(
              value: value[i],
              width: cellWidth,
              type: flag,
              onPressed: (){
                if (state.type == ReportType.LIST_OF_GOODS){
                  var goodId = state.ids[key - 1];
                  Navigator.of(context).pushNamed(Pages.good_history, arguments: {'goodId': goodId, 'start': widget.start, 'end': widget.end});
                  context.read<ReportDetailCubit>().init(context, widget.type, widget.start, widget.end, widget.groupId, widget.groupName);
                }else if (state.type == ReportType.LIST_OF_DOCUMENT ||  state.type == ReportType.DEBTS_BY_CUSTOMER || state.type == ReportType.DEBTS_BY_SUPPLIER){
                  var item = state.documents[key -1];
                  Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
                  context.read<ReportDetailCubit>().init(context, widget.type, widget.start, widget.end, widget.groupId, widget.groupName);
                }
              }));
        }
      }
      flag = !flag;
      results.add(Row(children: rows));
    });
    return results;
  }
  List<Widget> _buildFullRow(BuildContext context, ReportDetailState state) {
    List<Widget> results = [];
    bool flag = false;
    int columnCount = state.data.firstOrNull?.length ?? 1;
    double cellWidth = getCellWidth(context, columnCount);
    state.data.asMap().forEach((key, value) {
      List<Widget> rows = [];
      for (int i = 0; i < value.length; i++) {
        if (key == 0 || key == state.data.length - 1) {
          rows.add(_buildHighlightCell(value: value[i], width: cellWidth));
        } else {
          rows.add(_buildNormalCell(
              value: value[i],
              width: cellWidth,
              type: flag,
          onPressed: (){
            if (state.type == ReportType.LIST_OF_GOODS){
              var goodId = state.ids[key - 1];
              Navigator.of(context).pushNamed(Pages.good_history, arguments: {'goodId': goodId, 'start': widget.start, 'end': widget.end});
              context.read<ReportDetailCubit>().init(context, widget.type, widget.start, widget.end, widget.groupId, widget.groupName);
            }else if (state.type == ReportType.LIST_OF_DOCUMENT){
              var item = state.documents[key -1];
              Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
              context.read<ReportDetailCubit>().init(context, widget.type, widget.start, widget.end, widget.groupId, widget.groupName);
            }
          }));
        }
      }
      flag = !flag;
      results.add(Row(children: rows));
    });
    return results;
  }

  Widget _buildHighlightCell({String value = "", double width = MIN_WIDTH_CELL}) {
    return _buildCell(
        value: value,
        width: width,
        backgroundColor: UIConstants.primaryDarkColor,
        textColor: Colors.white,
        fontWeight: FontWeight.w600);
  }

  Widget _buildNormalCell({
    String value = "",
    bool type = true,
    double width = MIN_WIDTH_CELL,
    Function()? onPressed = null}) {
    if (type) {
      return _buildCell(
          value : value,
          width: width,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontWeight : FontWeight.w400,
          onPressed: onPressed,

      );
    } else {
      return _buildCell(
          value : value,
          width: width,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontWeight : FontWeight.w400,
          onPressed: onPressed,

      );
    }
  }

  Widget _buildCell(
      {String value = "",
        double width = MIN_WIDTH_CELL
        ,
        required Color backgroundColor,
        required Color textColor,
        required FontWeight fontWeight,
        Function()? onPressed = null,

      }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: width,
        color: backgroundColor,
        margin: EdgeInsets.all(1.0),
        child: Text(
          value,
          style: TextStyle(color: textColor, fontWeight: fontWeight),
        ),
      ),
    );
  }
  double getCellWidth(BuildContext context, int columnCount){
    if (Platform.isWindows){
      var screenWidth = MediaQuery.sizeOf(context).width - 20;
      var cellWidth = screenWidth / columnCount;
      var width = max(cellWidth, MIN_WIDTH_CELL);
      return width;
    }else{
      return MIN_WIDTH_CELL;
    }
  }
  Widget _buildContent(BuildContext context, ReportDetailState state){
    var text = sprintf(AppLocalizations.of(context)!.report_detail_header, [
      DateFormatFactory.getDateFormat().format(state.start!),
      DateFormatFactory.getDateFormat().format(state.end!),
      storage.getSelectedStoreName()
    ]);
    if (state.groupName != null){
      text += ", Group ${state.groupName}";
    }
    return Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [
                IconButton(onPressed: () async{
                  final updatedColumns = await showDialog(context: context, builder: (BuildContext context) {
                    return ColumnDisplayDialog(columns: state.columns);
                  });
                  context.read<ReportDetailCubit>().setColumns(updatedColumns);
                  context.read<ReportDetailCubit>().update();
                }, icon: Icon(Icons.settings)),
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(text),
                ))
            ,
              ],),
              if (Platform.isWindows)
                _buildWindowTable(context, state)
              else
                _buildMobileTable(context, state)

            ],
          ),
        ));
  }
  /*Widget _buildBody(BuildContext context, ReportDetailState state) {
    return Stack(children: [
      _buildContent(context, state),
      if (state.state is LoadingState)
        _buildLoading()
    ],);
  }*/
  _buildMobileTable(BuildContext context, ReportDetailState state){
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFirstColumn(context,state),
          ),
          Flexible(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRows(context,state)
                  )))
        ],
      ),
    );
  }
  _buildWindowTable(BuildContext context, ReportDetailState state){
    return SingleChildScrollView(
      child: Column(
        children: _buildFullRow(context, state),
      )
    );
  }
}
