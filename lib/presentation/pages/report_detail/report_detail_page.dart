import 'dart:io';

import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:good_manager/presentation/review_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';

class ReportDetailPage extends StatefulWidget {
  final ReportType type;
  final DateTime? start;
  final DateTime? end;

  ReportDetailPage(this.type, this.start, this.end);

  @override
  State<StatefulWidget> createState() {
    return ReportDetailPageState();
  }
}

class ReportDetailPageState extends State<ReportDetailPage> {
  @override
  void initState() {
    super.initState();
    ReviewManager.maybeRequestReview();
    init();
  }
  void init() async{
    context.read<ReportDetailCubit>().init(
      context,
      widget.type,
      widget.start,
      widget.end,
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ReportDetailCubit, ReportDetailState>(
      builder: (context, state) => Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context, state),
            body: _buildBody(context, state),
          ),
        ],
      ),
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {},
    );
  }

  dynamic _buildBody(BuildContext context, ReportDetailState state) {
    if (state.state is LoadingState) return _buildLoading();
    return _buildContent(context, state);
  }

  Container _buildLoading() {
    return Container(
      color: Colors.black.withValues(alpha: 125),
      // Semi-transparent background
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              context.tr("loading_data"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context, ReportDetailState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(widget.type.getTitle(context)),
        actions: [
          _buildExportExcelFileMenu(context, state),
          _buildPDFMenu(context, state),
        ],
      ),
    );
  }

  Widget _buildExportExcelFileMenu(
    BuildContext context,
    ReportDetailState state,
  ) {
    return IconButton(
      onPressed: () async {
        String fileName = '${getExportFileName(context, state)}.csv';
        saveAndExportCSV(context, state, fileName);
      },
      icon: Icon(FontAwesomeIcons.fileCsv),
    );
  }

  Future<void> saveAndExportCSV(
    BuildContext context,
    ReportDetailState state,
    String fileName,
  ) async {
    try {
      String csv = const ListToCsvConverter().convert(state.data);

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);

      await file.writeAsString(csv);
      final box = context.findRenderObject() as RenderBox?;
      final params = ShareParams(
        files: [XFile('${file.path}')],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      await SharePlus.instance.share(params);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("csv_saved_and_shared"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(sprintf(context.tr("error_with_details"), [e.toString()])),
        ),
      );
    }
  }

  Future<void> saveAndExportPDF(
    BuildContext context,
    ReportDetailState state,
    String fileName,
  ) async {
    try {
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context pwContext) =>
              _buildPDFContentList(context, state, font, fontBold),
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      final box = context.findRenderObject() as RenderBox?;
      final params = ShareParams(
        files: [XFile('${file.path}')],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      await SharePlus.instance.share(params);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("pdf_saved_and_shared"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(sprintf(context.tr("error_with_details"), [e.toString()])),
        ),
      );
    }
  }

  Widget _buildPDFMenu(BuildContext context, ReportDetailState state) {
    return IconButton(
      onPressed: () async {
        String fileName = '${getExportFileName(context, state)}.pdf';
        await saveAndExportPDF(context, state, fileName);
      },
      icon: FaIcon(FontAwesomeIcons.filePdf),
    );
  }

  String getExportFileName(BuildContext context, ReportDetailState state) {
    String name = state.type!.getTitle(context).replaceAll(" ", "");
    return name;
  }

  List<pw.Widget> _buildPDFContentList(
    BuildContext context,
    ReportDetailState state,
    pw.Font font,
    pw.Font fontBold,
  ) {
    var storeInfoText = getStoreInfoText();
    var periodInfoText = getPeriodInfoText(state);
    return [
      pw.Text(storeInfoText, style: pw.TextStyle(font: font)),
      if (periodInfoText.isNotEmpty)
        pw.Text(periodInfoText, style: pw.TextStyle(font: font)),
      pw.SizedBox(height: 16.0),
      if (state.data.isNotEmpty)
        pw.Table.fromTextArray(
          border: pw.TableBorder.all(color: PdfColors.grey),
          headerStyle: pw.TextStyle(font: fontBold, color: PdfColors.white),
          headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
          cellStyle: pw.TextStyle(font: font),
          data: state.data,
          headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          cellPadding: const pw.EdgeInsets.all(4),
        )
      else
        pw.Text(context.tr("no_data"), style: pw.TextStyle(font: font)),
    ];
  }

  List<Widget> _buildFirstColumn(
    BuildContext context,
    ReportDetailState state,
  ) {
    List<Widget> results = [];
    bool flag = true;
    state.data.asMap().forEach((key, value) {
      if (key == 0) {
        results.add(_buildHighlightCell(value: value.first));
      } else {
        results.add(
          _buildNormalCell(
            value: value.first,
            type: flag,
            onPressed: () async {
              var position = key - 1;
              if (position >= 0 && position < state.ids.length) {
                var id = state.ids[key - 1];
                if (state.type == ReportType.LIST_OF_GOODS && id != null) {
                  await Navigator.of(context).pushNamed(
                    Pages.good_history,
                    arguments: {
                      'goodId': id,
                      'start': widget.start,
                      'end': widget.end,
                    },
                  );
                } else if (state.type == ReportType.LIST_OF_DOCUMENT &&
                    id != null) {
                  var document =
                      await context.read<ReportDetailCubit>().getDocument(id);
                  await Navigator.of(context).pushNamed(
                    Pages.save_document,
                    arguments: {'item': document},
                  );
                } else if (state.type == ReportType.DEBTS_BY_SUPPLIER &&
                    id != null) {
                  await Navigator.of(context).pushNamed(
                    Pages.documents_history,
                    arguments: {
                      'supplierId': id,
                      'start': widget.start,
                      'end': widget.end,
                    },
                  );
                } else if (state.type == ReportType.DEBTS_BY_CUSTOMER &&
                    id != null) {
                  await Navigator.of(context).pushNamed(
                    Pages.documents_history,
                    arguments: {
                      'customerId': id,
                      'start': widget.start,
                      'end': widget.end,
                    },
                  );
                } else if (state.type == ReportType.INBOUND_PAYMENTS) {
                  PaymentsSetting setting = PaymentsSetting(
                    sortByDateNewestFirst: true,
                    selectedCategoryIds: {id},
                    selectedWalletIds: {},
                    selectedCustomerIds: {},
                    selectedSupplierIds: {},
                    startDate: widget.start,
                    endDate: widget.end,
                  );
                  await Navigator.of(context).pushNamed(
                    Pages.payments,
                    arguments: {'setting': setting, 'initialIndex': 1},
                  );
                } else if (state.type == ReportType.OUTBOUND_PAYMENTS) {
                  PaymentsSetting setting = PaymentsSetting(
                    sortByDateNewestFirst: true,
                    selectedCategoryIds: {id},
                    selectedWalletIds: {},
                    selectedCustomerIds: {},
                    selectedSupplierIds: {},
                    startDate: widget.start,
                    endDate: widget.end,
                  );
                  await Navigator.of(context).pushNamed(
                    Pages.payments,
                    arguments: {'setting': setting, 'initialIndex': 2},
                  );
                } else if (state.type == ReportType.LIST_OF_WALLETS) {
                  PaymentsSetting setting = PaymentsSetting(
                    sortByDateNewestFirst: true,
                    selectedCategoryIds: {},
                    selectedWalletIds: {id!},
                    selectedCustomerIds: {},
                    selectedSupplierIds: {},
                    startDate: widget.start,
                    endDate: widget.end,
                  );
                  await Navigator.of(context).pushNamed(
                    Pages.payments,
                    arguments: {'setting': setting, 'initialIndex': 0},
                  );
                } else if (state.type == ReportType.RE_ORDER && id != null) {
                  var good =
                      await context.read<ReportDetailCubit>().getGood(id);
                  await Navigator.of(context)
                      .pushNamed(Pages.save_good, arguments: {'item': good});
                } else if (state.type == ReportType.LIST_OF_CUSTOMER_PAYMENTS &&
                    id != null) {
                  PaymentsSetting setting = PaymentsSetting(
                    sortByDateNewestFirst: true,
                    selectedCategoryIds: {},
                    selectedWalletIds: {},
                    selectedCustomerIds: {id},
                    selectedSupplierIds: {},
                    startDate: widget.start,
                    endDate: widget.end,
                  );
                  await Navigator.of(context).pushNamed(
                    Pages.payments,
                    arguments: {'setting': setting, 'initialIndex': 1},
                  );
                } else if (state.type == ReportType.LIST_OF_SUPPLIER_PAYMENTS &&
                    id != null) {
                  PaymentsSetting setting = PaymentsSetting(
                    sortByDateNewestFirst: true,
                    selectedCategoryIds: {},
                    selectedWalletIds: {},
                    selectedCustomerIds: {},
                    selectedSupplierIds: {id},
                    startDate: widget.start,
                    endDate: widget.end,
                  );
                  await Navigator.of(context).pushNamed(
                    Pages.payments,
                    arguments: {'setting': setting, 'initialIndex': 2},
                  );
                } else if (state.type == ReportType.GOOD_INFO &&
                    id != null){
                  var good =
                  await context.read<ReportDetailCubit>().getGood(id);
                  await Navigator.of(context).pushNamed(
                    Pages.save_good,
                    arguments: {'item': good},
                  );

                }
              }
            },
          ),
        );
        flag = !flag;
      }
    });
    return results;
  }

  List<Widget> _buildRows(BuildContext context, ReportDetailState state) {
    List<Widget> results = [];
    bool flag = false;
    state.data.asMap().forEach((key, value) {
      List<Widget> rows = [];
      for (int i = 1; i < value.length; i++) {
        if (key == 0) {
          rows.add(_buildHighlightCell(value: value[i]));
        } else {
          rows.add(
            _buildNormalCell(value: value[i], type: flag),
          );
        }
      }
      flag = !flag;
      results.add(Row(children: rows));
    });
    return results;
  }

  Widget _buildHighlightCell({String value = ""}) {
    return _buildCell(
      value: value,
      backgroundColor: ColorUtils.getHeaderBgColor(context),
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildNormalCell({
    String value = "",
    bool type = true,
    Function()? onPressed = null,
  }) {
    if (type) {
      return _buildCell(
        value: value,
        backgroundColor: ColorUtils.getItemBgColor1(context),
        fontWeight: FontWeight.w400,
        onPressed: onPressed,
      );
    } else {
      return _buildCell(
        value: value,
        backgroundColor: ColorUtils.getItemBgColor2(context),
        fontWeight: FontWeight.w400,
        onPressed: onPressed,
      );
    }
  }

  Widget _buildCell({
    String value = "",
    required Color backgroundColor,
    required FontWeight fontWeight,
    Function()? onPressed = null,
  }) {
    final cell = Container(
      alignment: Alignment.center,
      width: 132,
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: backgroundColor,
      margin: const EdgeInsets.all(1),
      child: Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, fontWeight: fontWeight),
      ),
    );
    if (onPressed == null) return cell;
    return InkWell(onTap: onPressed, child: cell);
  }

  String getStoreInfoText() {
    return sprintf(
      context.tr("report_detail_store"),
      [context.read<ReportDetailCubit>().getSelectedStoreName()],
    );
  }

  String getPeriodInfoText(ReportDetailState state) {
    var periodInfoText = "";
    if (state.start != null && state.end != null) {
      periodInfoText =
          sprintf(context.tr("report_detail_period_time"), [
        DateFormatFactory.getDateFormat().format(state.start!),
        DateFormatFactory.getDateFormat().format(state.end!),
      ]);
    }
    return periodInfoText;
  }

  Widget _buildContent(BuildContext context, ReportDetailState state) {
    var storeInfoText = getStoreInfoText();
    var periodInfoText = getPeriodInfoText(state);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(storeInfoText),
                        if (periodInfoText.isNotEmpty) Text(periodInfoText),
                        Text(
                          context.tr("hint_tap_first_column"),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final updatedColumns = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ColumnDisplayDialog(columns: state.columnReports);
                      },
                    );
                    if (updatedColumns != null) {
                      context
                          .read<ReportDetailCubit>()
                          .setColumns(updatedColumns, context);
                    }
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            _buildMobileTable(context, state),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildMobileTable(
    BuildContext context,
    ReportDetailState state,
  ) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFirstColumn(context, state),
          ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRows(context, state),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
