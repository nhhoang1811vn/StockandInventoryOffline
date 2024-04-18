import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sprintf/sprintf.dart';

import '../../constants.dart';

class ReportDetailPage extends StatelessWidget {
  final ReportType type;
  final DateTime start;
  final DateTime end;

  ReportDetailPage(this.type, this.start, this.end);

  @override
  Widget build(BuildContext context) {
    context.read<ReportDetailCubit>().init(context, type, start, end);

    return BlocConsumer<ReportDetailCubit, ReportDetailState>(
        builder: (context, state) => Scaffold(appBar: _buildAppBar(context, state), body: _buildBody(context, state)),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {});
  }

  PreferredSize _buildAppBar(BuildContext context, ReportDetailState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(type.getTitle(context)),
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
      //String filePath = "$destinationPath/${getExportPdfFileName(context, state)}.csv";
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
        Config.dateFormat.format(state.start!),
        Config.dateFormat.format(state.end!),
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
        } else {
          rows.add(_buildNormalCell(value[i], flag));
        }
      }
      flag = !flag;
      results.add(Row(children: rows));
    });
    return results;
  }

  Widget _buildHighlightCell(String value) {
    return _buildCell(value, UIConstants.primaryDarkColor, Colors.white, FontWeight.w600);
  }

  Widget _buildNormalCell(String value, bool type) {
    if (type) {
      return _buildNormalCellType1(value);
    } else {
      return _buildNormalCellType2(value);
    }
  }

  Widget _buildNormalCellType1(String value) {
    return _buildCell(value, Colors.grey.shade200, Colors.black, FontWeight.w400);
  }

  Widget _buildNormalCellType2(String value) {
    return _buildCell(value, Colors.white, Colors.black, FontWeight.w400);
  }

  Widget _buildCell(String value, Color backgroundColor, Color textColor, FontWeight fontWeight) {
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

  Widget _buildBody(BuildContext context, ReportDetailState state) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
          ),
        ));
  }
}
