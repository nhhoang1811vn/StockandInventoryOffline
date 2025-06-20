import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/payments_setting.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../constants.dart';
import 'components/field_display_dialog.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<ColumnReport> columns = getColumns(widget.type);
      context.read<ReportDetailCubit>().initColumn(columns);
    });
  }

  List<ColumnReport> getColumns(ReportType type) {
    switch (type) {
      case ReportType.LIST_OF_GOODS:
        return [
          ColumnReport(AppLocalizations.of(context)!.field_name,
              showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.folder,
              isPickValues: true),
          ColumnReport(AppLocalizations.of(context)!.field_bar_code),
          ColumnReport(AppLocalizations.of(context)!.field_start_period,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_in, showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_out,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_end_period,
              showTotal: true)
        ];
      case ReportType.LIST_OF_DOCUMENT:
        return [
          ColumnReport(AppLocalizations.of(context)!.field_date,
              showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_name),
          ColumnReport(AppLocalizations.of(context)!.field_document_type,
              isPickValues: true),
          ColumnReport(AppLocalizations.of(context)!.field_person_name,
              isPickValues: true),
          ColumnReport(AppLocalizations.of(context)!.field_quantity,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_amount,
              showTotal: true),
        ];
      case ReportType.DEBTS_BY_SUPPLIER:
        return [
          ColumnReport(AppLocalizations.of(context)!.field_supplier,
              isPickValues: true, showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_amount,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_paid,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_remaining,
              showTotal: true),
        ];
      case ReportType.DEBTS_BY_CUSTOMER:
        return [
          ColumnReport(AppLocalizations.of(context)!.field_customer,
              isPickValues: true, showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_amount,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_paid,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_remaining,
              showTotal: true),
        ];
      case ReportType.LIST_OF_WALLETS:
        return [
          ColumnReport(AppLocalizations.of(context)!.label_wallet_name,
              showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_start_period,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_in, showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_out,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_end_period,
              showTotal: true),
        ];
      case ReportType.LIST_OF_SUPPLIER_PAYMENTS:
        return [
          ColumnReport(AppLocalizations.of(context)!.label_supplier_name, showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_amount,  showTotal: true),
        ];
      case ReportType.LIST_OF_CUSTOMER_PAYMENTS:
        return [
          ColumnReport(AppLocalizations.of(context)!.label_customer_name, showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_amount, showTotal: true),
        ];
      case ReportType.RE_ORDER:
        return [
          ColumnReport(AppLocalizations.of(context)!.field_name,
              showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_bar_code),
          ColumnReport(AppLocalizations.of(context)!.field_quantity,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_min_quantity),
          ColumnReport(AppLocalizations.of(context)!.field_reorder,
              showTotal: true),
          ColumnReport(AppLocalizations.of(context)!.field_purchase_price),
          ColumnReport(AppLocalizations.of(context)!.field_amount,
              showTotal: true),
        ];
      case ReportType.INBOUND_PAYMENTS:
      case ReportType.OUTBOUND_PAYMENTS:
        return [
          ColumnReport(AppLocalizations.of(context)!.label_category_name,
              isPickValues: true, showTotalText: true),
          ColumnReport(AppLocalizations.of(context)!.field_amount,
              showTotal: true),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ReportDetailCubit>().init(AppLocalizations.of(context)!, true,
        widget.type, widget.start, widget.end);
    return BlocConsumer<ReportDetailCubit, ReportDetailState>(
        builder: (context, state) => Stack(
              children: [
                Scaffold(
                    appBar: _buildAppBar(context, state),
                    body: _buildBody(context, state)),
              ],
            ),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {});
  }

  _buildBody(BuildContext context, ReportDetailState state) {
    if (state.state is LoadingState) return _buildLoading();
    return _buildContent(context, state);
  }

  _buildLoading() {
    return Container(
        color: Colors.black.withValues(alpha: 125),
        // Semi-transparent background
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.loading_data,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                )),
          ],
        )));
  }

  PreferredSize _buildAppBar(BuildContext context, ReportDetailState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(widget.type.getTitle(context)),
        actions: [
          _buildExportExcelFileMenu(context, state),
          _buildPDFMenu(context, state)
        ],
      ),
    );
  }

  Widget _buildExportExcelFileMenu(
      BuildContext context, ReportDetailState state) {
    return IconButton(
        onPressed: () async {
          String fileName = '${getExportFileName(context, state)}.csv';
          saveAndExportCSV(context, state, fileName);
        },
        icon: FaIcon(FontAwesomeIcons.fileCsv));
  }

  Future<void> saveAndExportCSV(
      BuildContext context, ReportDetailState state, String fileName) async {
    try {
      String csv = const ListToCsvConverter().convert(state.data);

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);

      await file.writeAsString(csv);
      // Export via share dialog (iOS-compatible)
      final params = ShareParams(
        files: [XFile('${file.path}')],
      );
      await SharePlus.instance.share(params);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV saved and shared successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> saveAndExportPDF(
      BuildContext context, ReportDetailState state, String fileName) async {
    try {
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.robotoRegular();
      pdf.addPage(
        pw.Page(
            build: (pw.Context pwContext) =>
                _buildPDFContent(context, state, font)),
      );

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      // Export via share dialog (iOS-compatible)
      final params = ShareParams(
        files: [XFile('${file.path}')],
      );
      await SharePlus.instance.share(params);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved and shared successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Widget _buildPDFMenu(BuildContext context, ReportDetailState state) {
    return IconButton(
        onPressed: () async {
          String fileName = '${getExportFileName(context, state)}.pdf';
          await saveAndExportPDF(context, state, fileName);
        },
        icon: FaIcon(FontAwesomeIcons.filePdf));
  }

  String getExportFileName(BuildContext context, ReportDetailState state) {
    String name = state.type!.getTitle(context).replaceAll(" ", "");
    return name;
  }

  pw.Widget _buildPDFContent(
      BuildContext context, ReportDetailState state, pw.Font font) {
    var storeInfoText = getStoreInfoText();
    var periodInfoText = getPeriodInfoText(state);
    return pw.Column(children: [
      pw.Text(storeInfoText, style: pw.TextStyle(font: font)),
      if (periodInfoText.isNotEmpty)
        pw.Text(periodInfoText, style: pw.TextStyle(font: font)),
      pw.SizedBox(height: 16.0),
      pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            ...List.generate(
                state.data.length,
                (indexI) => pw.TableRow(
                        decoration: pw.BoxDecoration(
                            color:
                                indexI == 0 ? PdfColors.blue : PdfColors.white),
                        children: [
                          ...List.generate(
                              state.data[indexI].length,
                              (indexJ) => pw.Padding(
                                  padding: pw.EdgeInsets.all(8.0),
                                  child: pw.Text(state.data[indexI][indexJ],
                                      style: pw.TextStyle(
                                          font: font,
                                          color: indexI == 0
                                              ? PdfColors.white
                                              : PdfColors.black))))
                        ]))
          ])
    ]);
  }

  List<Widget> _buildFirstColumn(
      BuildContext context, ReportDetailState state) {
    List<Widget> results = [];
    bool flag = true;
    state.data.asMap().forEach((key, value) {
      if (key == 0) {
        results.add(_buildHighlightCell(value: value.first));
      } else {
        results.add(_buildNormalCell(
            value: value.first,
            type: flag,
            onPressed: () async {
              var position = key - 1;
              if (position >= 0 && position < state.ids.length) {
                var id = state.ids[key - 1];
                if (state.type == ReportType.LIST_OF_GOODS && id != null) {
                  await Navigator.of(context).pushNamed(Pages.good_history,
                      arguments: {
                        'goodId': id,
                        'start': widget.start,
                        'end': widget.end
                      });
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.LIST_OF_DOCUMENT &&
                    id != null) {
                  var document =
                      await context.read<ReportDetailCubit>().getDocument(id);
                  await Navigator.of(context).pushNamed(Pages.save_document,
                      arguments: {'item': document});
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.DEBTS_BY_SUPPLIER &&
                    id != null) {
                  await Navigator.of(context).pushNamed(Pages.documents_history, arguments: {
                    'supplierId': id,
                    'start': widget.start,
                    'end': widget.end
                  });
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.DEBTS_BY_CUSTOMER &&
                    id != null) {
                  await Navigator.of(context).pushNamed(Pages.documents_history, arguments: {
                    'customerId': id,
                    'start': widget.start,
                    'end': widget.end
                  });
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.INBOUND_PAYMENTS) {
                  PaymentsSetting setting = PaymentsSetting(
                      selectedCategoryIds: {id},
                      selectedWalletIds: {},
                      selectedCustomerIds: {},
                      selectedSupplierIds: {},
                      startDate: widget.start,
                      endDate: widget.end);
                  await Navigator.of(context).pushNamed(Pages.payments,
                      arguments: {'setting': setting, 'initialIndex': 1});
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.OUTBOUND_PAYMENTS) {
                  PaymentsSetting setting = PaymentsSetting(
                      selectedCategoryIds: {id},
                      selectedWalletIds: {},
                      selectedCustomerIds: {},
                      selectedSupplierIds: {},
                      startDate: widget.start,
                      endDate: widget.end);
                  await Navigator.of(context).pushNamed(Pages.payments,
                      arguments: {'setting': setting, 'initialIndex': 2});
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.LIST_OF_WALLETS) {
                  PaymentsSetting setting = PaymentsSetting(
                      selectedCategoryIds: {},
                      selectedWalletIds: {id!},
                      selectedCustomerIds: {},
                      selectedSupplierIds: {},
                      startDate: widget.start,
                      endDate: widget.end);
                  await Navigator.of(context).pushNamed(Pages.payments,
                      arguments: {'setting': setting, 'initialIndex': 0});
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.RE_ORDER && id != null) {
                  var good =
                      await context.read<ReportDetailCubit>().getGood(id);
                  await Navigator.of(context)
                      .pushNamed(Pages.save_good, arguments: {'item': good});
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.LIST_OF_CUSTOMER_PAYMENTS && id != null){
                  PaymentsSetting setting = PaymentsSetting(
                      selectedCategoryIds: {},
                      selectedWalletIds: {},
                      selectedCustomerIds: {id},
                      selectedSupplierIds: {},
                      startDate: widget.start,
                      endDate: widget.end);
                  await Navigator.of(context).pushNamed(Pages.payments,
                      arguments: {'setting': setting, 'initialIndex': 1});
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                } else if (state.type == ReportType.LIST_OF_SUPPLIER_PAYMENTS && id != null){
                  PaymentsSetting setting = PaymentsSetting(
                      selectedCategoryIds: {},
                      selectedWalletIds: {},
                      selectedCustomerIds: {},
                      selectedSupplierIds: {id},
                      startDate: widget.start,
                      endDate: widget.end);
                  await Navigator.of(context).pushNamed(Pages.payments,
                      arguments: {'setting': setting, 'initialIndex': 2});
                  context.read<ReportDetailCubit>().refresh(AppLocalizations.of(context)!);
                }
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
    state.data.asMap().forEach((key, value) {
      List<Widget> rows = [];
      for (int i = 1; i < value.length; i++) {
        if (key == 0) {
          rows.add(_buildHighlightCell(value: value[i]));
        } else {
          rows.add(
              _buildNormalCell(value: value[i], type: flag, onPressed: () {}));
        }
      }
      flag = !flag;
      results.add(Row(children: rows));
    });
    return results;
  }

  // List<Widget> _buildFullRow(BuildContext context, ReportDetailState state) {
  //   List<Widget> results = [];
  //   bool flag = false;
  //   state.data.asMap().forEach((key, value) {
  //     List<Widget> rows = [];
  //     for (int i = 0; i < value.length; i++) {
  //       if (key == 0 || key == state.data.length - 1) {
  //         rows.add(_buildHighlightCell(value: value[i]));
  //       } else {
  //         rows.add(_buildNormalCell(
  //             value: value[i],
  //             //width: cellWidth,
  //             type: flag,
  //             onPressed: () {
  //               if (state.type == ReportType.LIST_OF_GOODS) {
  //                 var good = state.goods[key - 1];
  //                 //Navigator.of(context).pushNamed(Pages.good_history, arguments: {'goodId': goodId, 'start': widget.start, 'end': widget.end});
  //                 Navigator.of(context)
  //                     .pushNamed(Pages.save_good, arguments: {'item': good});
  //                 context
  //                     .read<ReportDetailCubit>()
  //                     .init(context, widget.type, widget.start, widget.end);
  //               } else if (state.type == ReportType.LIST_OF_DOCUMENT) {
  //                 var item = state.documents[key - 1];
  //                 Navigator.of(context).pushNamed(Pages.save_document,
  //                     arguments: {'item': item});
  //                 context
  //                     .read<ReportDetailCubit>()
  //                     .init(context, widget.type, widget.start, widget.end);
  //               }
  //             }));
  //       }
  //     }
  //     flag = !flag;
  //     results.add(Row(children: rows));
  //   });
  //   return results;
  // }

  Widget _buildHighlightCell({String value = ""}) {
    return _buildCell(
        value: value,
        //bac
        backgroundColor: ColorUtils.getHeaderBgColor(context),
        //textColor: Colors.white,
        fontWeight: FontWeight.w600);
  }

  Widget _buildNormalCell(
      {String value = "", bool type = true, Function()? onPressed = null}) {
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
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 20,
        color: backgroundColor,
        margin: EdgeInsets.all(1.0),
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, fontWeight: fontWeight),
        ),
      ),
    );
  }

  String getStoreInfoText() {
    return sprintf(AppLocalizations.of(context)!.report_detail_store,
        [storage.getSelectedStoreName()]);
  }

  String getPeriodInfoText(ReportDetailState state) {
    var periodInfoText = "";
    if (state.start != null && state.end != null) {
      periodInfoText =
          sprintf(AppLocalizations.of(context)!.report_detail_period_time, [
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
                    Text(AppLocalizations.of(context)!.hint_tap_first_column)
                  ],
                ),
              )),
              IconButton(
                  onPressed: () async {
                    final updatedColumns = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ColumnDisplayDialog(columns: state.columns);
                        });
                    if (updatedColumns != null) {
                      context
                          .read<ReportDetailCubit>()
                          .setColumns(updatedColumns);
                      context
                          .read<ReportDetailCubit>()
                          .update(AppLocalizations.of(context)!);
                    }
                  },
                  icon: Icon(Icons.settings)),
            ],
          ),
          _buildMobileTable(context, state)
          // if (Platform.isWindows)
          //   _buildWindowTable(context, state)
          // else
          //   _buildMobileTable(context, state)
        ],
      ),
    ));
  }

  _buildMobileTable(BuildContext context, ReportDetailState state) {
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
                      children: _buildRows(context, state))))
        ],
      ),
    );
  }

// _buildWindowTable(BuildContext context, ReportDetailState state) {
//   return SingleChildScrollView(
//       child: Column(
//     children: _buildFullRow(context, state),
//   ));
// }
}
