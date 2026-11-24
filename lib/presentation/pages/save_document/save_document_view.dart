import 'dart:io';

import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';
import 'package:good_manager/presentation/pages/save_document/components/filter_transaction_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../../app.dart';
import '../../../constant/constant.dart';
import '../../../data/app_settings.dart';
import 'document_table_builder.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/util.dart';
import '../../blocs/add_quantity_and_price/add_quantity_and_price_dialog.dart';
import '../../dialog/dialog.dart';
import '../../review_manager.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'components/document_transaction_item_row.dart';

enum OverflowItemMenu { export_csv, export_pdf, help }

class SaveDocumentPage extends StatefulWidget {
  final Document item;

  SaveDocumentPage(this.item) : super();

  @override
  State<StatefulWidget> createState() {
    return SaveDocumentPageState();
  }
}

class SaveDocumentPageState extends State<SaveDocumentPage> {
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<SaveDocumentCubit>().init(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    personNameController.text = widget.item.personName ?? '';
    dateController.text =
        DateFormatFactory.getDateAndTimeFormat().format(widget.item.date);
    return BlocConsumer<SaveDocumentCubit, SaveDocumentState>(
      listener: (context, state) async {
        if (state.state is SaveDocumentFailedState) {
          ToastUtils.showErrorToast(state.exceptionError);
        } else if (state.state is SaveDocumentSuccessfulState) {
          ReviewManager.maybeRequestReview();
          ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
          Navigator.of(context).pop();
        } else if (state.state is OpenPersonListState) {
          if (state.item?.type == DocumentType.incoming) {
            final result = await Navigator.of(context).pushNamed(
              Pages.supplier_list,
              arguments: {"isSelection": true},
            );
            if (result != null) {
              Supplier item = result as Supplier;
              context.read<SaveDocumentCubit>().onPersonNameChanged(item.name);
              context.read<SaveDocumentCubit>().onPersonChanged(item.id!);

              personNameController.text = item.name;
            }
          } else {
            final result = await Navigator.of(context).pushNamed(
              Pages.customer_list,
              arguments: {"isSelection": true},
            );
            if (result != null) {
              Customer item = result as Customer;
              context.read<SaveDocumentCubit>().onPersonNameChanged(item.name);
              context.read<SaveDocumentCubit>().onPersonChanged(item.id!);

              personNameController.text = item.name;
            }
          }
        } else if (state.state is OpenGoodListState) {
          await Navigator.of(context).pushNamed(
            Pages.good_list,
            arguments: {"isSelection": true, "document": state.item},
          );
          context.read<SaveDocumentCubit>().loadTransactions();
        } else if (state.state is OpenSaveGoodState) {
          final finalState = state.state as OpenSaveGoodState;
          final transaction = finalState.item;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_good,
            arguments: {
              "item": transaction.good,
              "document": state.item,
              "transaction": transaction,
            },
          );
          if (result != null) {
            context.read<SaveDocumentCubit>().loadTransactions();
          }
        } else if (state.state is OpenBarcodeScannerPageState) {
          var result = await Utils.scanBarcode(context);
          if (result != null) {
            context.read<SaveDocumentCubit>().findGood(result);
          }
        } else if (state.state is OpenHelpPageState) {
          Navigator.of(context).pushNamed(
            Pages.help,
            arguments: {
              "title": context.tr("documents"),
              "content":
                  MDProviderFactory.get().getHelpText(HelpType.DOCUMENTS),
            },
          );
        } else if (state.state is OpenSaveGoodPageWithBarcodeState) {
          final finalState = state.state as OpenSaveGoodPageWithBarcodeState;
          final barcode = finalState.barcode;
          final good = Good();
          good.name = barcode;
          good.barCode = barcode;
          good.storeId = context.read<SaveDocumentCubit>().getSelectedStoreId();

          DocumentTransaction transaction = DocumentTransaction();
          transaction.quantity = 1;
          transaction.price = 0.0;
          transaction.type = widget.item.type;
          transaction.storeId =
              context.read<SaveDocumentCubit>().getSelectedStoreId();

          final result = await Navigator.of(context).pushNamed(
            Pages.save_good,
            arguments: {
              "item": good,
              "document": state.item,
              "transaction": transaction,
            },
          );

          if (result != null) {
            Map data = result as Map<dynamic, dynamic>;
            Document document = data['document'] as Document;
            context.read<SaveDocumentCubit>().updateDocument(document);
            context.read<SaveDocumentCubit>().loadTransactions();
            context.read<SaveDocumentCubit>().onBatchScanMenuClicked();
          }
        } else if (state.state is OpenInputQuantityDialogState) {
          final finalState = state.state as OpenInputQuantityDialogState;
          final good = finalState.good;
          Map<dynamic, dynamic>? result = await showDialog(
            context: context,
            builder: (_) => AddQuantityAndPriceWidget(good, widget.item.type),
            barrierDismissible: false,
          );
          if (result != null) {
            double quantity = result["quantity"] ?? 0;
            double price = result["price"] ?? 0.0;
            context
                .read<SaveDocumentCubit>()
                .saveThenAddTransaction(good, quantity, price);
            context.read<SaveDocumentCubit>().onBatchScanMenuClicked();
          }
        }
      },
      listenWhen: (state1, state2) => state1.state != state2.state,
      builder: (context, state) {
        final theme = Theme.of(context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SaveObjectAppBar(
            title: widget.item.type == DocumentType.incoming
                ? context.tr("incoming")
                : context.tr("outgoing"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  context.read<SaveDocumentCubit>().onSaveMenuClicked();
                },
              ),
              PopupMenuButton<OverflowItemMenu>(
                offset: const Offset(0, 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem<OverflowItemMenu>(
                    value: OverflowItemMenu.export_csv,
                    child: Text(context.tr("action_export_csv")),
                  ),
                  PopupMenuItem<OverflowItemMenu>(
                    value: OverflowItemMenu.export_pdf,
                    child: Text(context.tr("action_export_pdf")),
                  ),
                  PopupMenuItem<OverflowItemMenu>(
                    value: OverflowItemMenu.help,
                    child: Text(context.tr("action_help")),
                  ),
                ],
                onSelected: (item) => handleClick(context, item, state),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            context.tr("document_information"),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    labelText: context.tr("document_no"),
                                    hintText: context.tr("hint_name"),
                                    initialValue: state.name.value,
                                    onChanged: (value) => context
                                        .read<SaveDocumentCubit>()
                                        .nameChanged(value),
                                    keyboardType: TextInputType.name,
                                    error:
                                        state.name.displayError?.text(context),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: personNameController,
                                    labelText: state.item?.type ==
                                            DocumentType.incoming
                                        ? context.tr("label_supplier_name")
                                        : context.tr("label_customer_name"),
                                    hintText: context.tr("hint_select"),
                                    suffix: const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                    ),
                                    keyboardType: TextInputType.none,
                                    readOnly: true,
                                    onTapped: () {
                                      context
                                          .read<SaveDocumentCubit>()
                                          .onPersonClicked();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            AppTextField(
                              controller: dateController,
                              labelText: context.tr("field_date_time"),
                              keyboardType: TextInputType.datetime,
                              readOnly: true,
                              onTapped: () {
                                DatePicker.showDateTimePicker(
                                  context,
                                  locale: MyApp.getDatePickerLocaleType(
                                    context,
                                  ),
                                  showTitleActions: true,
                                  minTime: Config.minTime,
                                  maxTime: Config.maxTime,
                                  onConfirm: (date) {
                                    context
                                        .read<SaveDocumentCubit>()
                                        .dateChanged(date);
                                    dateController.text =
                                        DateFormatFactory.getDateAndTimeFormat()
                                            .format(date);
                                  },
                                  currentTime: state.date,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              labelText: context.tr("label_description"),
                              hintText: context.tr("hint_description"),
                              maxLines: null,
                              minLines: 1,
                              initialValue: state.description,
                              onChanged: (value) => context
                                  .read<SaveDocumentCubit>()
                                  .descriptionChanged(value),
                              keyboardType: TextInputType.multiline,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            context.tr("goods_information"),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SearchBarWidget(
                                    onTextChanged: (newValue) {
                                      context
                                          .read<SaveDocumentCubit>()
                                          .onSearchTextChanged(newValue);
                                    },
                                    focusNode: searchTextFocusNode,
                                    showCamera: true,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.tune),
                                  onPressed: () {
                                    showFilterBottomSheet(state);
                                  },
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                            if (state.state is LoadingState)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            else ...[
                              if (state.transactions.isEmpty)
                                _buildEmptyTransaction(context)
                              else
                                _buildTransactionsView(context, state),
                              SizedBox(
                                height: state.transactions.isEmpty ? 32 : 12,
                              ),
                              _buildGoodActionButtons(context),
                              const SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildGoodsSummaryBar(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoodActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              context.tr("action_add_good"),
              () => context.read<SaveDocumentCubit>().onAddGoodClicked(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MyOutlineButton(
              context.tr("action_batch_scan"),
              () => context.read<SaveDocumentCubit>().onBatchScanMenuClicked(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodsSummaryBar(SaveDocumentState state) {
    final showAmount =
        AppSettings.getGoodPropertiesSettings().showPriceFor(widget.item.type);
    return SummaryLine([
      SummaryLine.item(
        context.tr("goods"),
        state.transactions.length.toString(),
      ),
      SummaryLine.item(
        context.tr("quantity"),
        StringUtils.getQuantityText(state.totalQuantity),
      ),
      if (showAmount)
        SummaryLine.item(
          context.tr("amount"),
          CurrencyFormatter.format(context, state.totalAmount),
        ),
    ]);
  }

  void handleClick(
    BuildContext context,
    OverflowItemMenu item,
    SaveDocumentState state,
  ) {
    switch (item) {
      case OverflowItemMenu.export_csv:
        onExportCSV(state);
        break;
      case OverflowItemMenu.export_pdf:
        onExportPDF(state);
        break;
      case OverflowItemMenu.help:
        context.read<SaveDocumentCubit>().onHelpMenuClicked();
        break;
    }
  }

  void showFilterBottomSheet(SaveDocumentState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext mContext) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (mContext, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: FilterTransactionWidget(
                onResetAllPressed: () {
                  context.read<SaveDocumentCubit>().resetAllFilter();
                  Navigator.of(context).pop();
                },
                onApplyPressed: (setting) {
                  context.read<SaveDocumentCubit>().applyFilter(setting);
                  Navigator.of(context).pop();
                },
                setting: state.setting,
              ),
            );
          },
        );
      },
    );
  }

  void onExportCSV(SaveDocumentState state) async {
    String fileName = 'Document_${state.name.value}.csv';
    await saveCSVFile(context, state, fileName);
  }

  void onExportPDF(SaveDocumentState state) async {
    String fileName = 'Document_${state.name.value}.pdf';
    await saveAndExportPDF(context, state, fileName);
  }

  Future<void> saveAndExportPDF(
    BuildContext context,
    SaveDocumentState state,
    String fileName,
  ) async {
    var myCompany = await context.read<SaveDocumentCubit>().getMyCompany();
    try {
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.robotoRegular();
      pdf.addPage(
        pw.Page(
          build: (pw.Context pwContext) =>
              _buildPDFContent(context, state, font, myCompany),
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      // Export via share dialog (iOS-compatible)
      // final params = ShareParams(
      //   files: [XFile('${file.path}')],
      // );
      // await SharePlus.instance.share(params);
      final box = context.findRenderObject() as RenderBox?;
      final params = ShareParams(
        files: [XFile('${file.path}')],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      await SharePlus.instance.share(params);

      ToastUtils.showSuccessToast(context.tr("pdf_saved_and_shared"));
    } catch (e) {
      ToastUtils.showErrorToast(sprintf(context.tr("error_with_details"), [e.toString()]));
    }
  }

  pw.Widget _buildPDFContent(
    BuildContext context,
    SaveDocumentState state,
    pw.Font font,
    MyCompany? myCompany,
  ) {
    List<List<String>> table = getTableData(state);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          context.tr("menu_item_my_company"),
          style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          "${context.tr("field_my_company_name")}: ${myCompany?.companyName ?? ""}",
          style: pw.TextStyle(font: font),
        ),
        pw.Row(
          children: [
            pw.Text(
              "${context.tr("label_address")}: ${myCompany?.address ?? ""}",
              style: pw.TextStyle(font: font),
            ),
            pw.Spacer(),
            pw.Text(
              "${context.tr("label_email")}: ${myCompany?.email ?? ""}",
              style: pw.TextStyle(font: font),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Text(
              "${context.tr("label_phone_number")}: ${myCompany?.phone ?? ""}",
              style: pw.TextStyle(font: font),
            ),
            pw.Spacer(),
            pw.Text(
              "${context.tr("label_tax_id")}: ${myCompany?.taxId ?? ""}",
              style: pw.TextStyle(font: font),
            ),
          ],
        ),
        pw.Text(
          "${context.tr("label_bank_details")}: ${myCompany?.bankDetails ?? ""}",
          style: pw.TextStyle(font: font),
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          context.tr("document_information"),
          style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
        ),
        pw.Row(
          children: [
            pw.Text(
              "${context.tr("document_name_no")}: ${state.name.value.toString()}",
              style: pw.TextStyle(font: font),
            ),
            pw.Spacer(),
            pw.Text(
              "${context.tr("field_date_time")}: ${DateFormatFactory.getDateAndTimeFormat().format(state.date!)}",
              style: pw.TextStyle(font: font),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Text(
              "${context.tr("person_name")}: ${state.personName ?? ""}",
              style: pw.TextStyle(font: font),
            ),
            pw.Spacer(),
            pw.Text(
              "${context.tr("label_description")}: ${state.description}",
              style: pw.TextStyle(font: font),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          context.tr("goods"),
          style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
        ),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            ...List.generate(
              table.length,
              (indexI) => pw.TableRow(
                children: [
                  ...List.generate(
                    table[indexI].length,
                    (indexJ) => pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        table[indexI][indexJ],
                        style: pw.TextStyle(font: font),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<List<String>> getTableData(SaveDocumentState state) {
    return buildDocumentTable(
      transactions: state.allTransactions,
      type: widget.item.type,
      properties: AppSettings.getGoodPropertiesSettings(),
      tr: context.tr,
    );
  }

  Future<void> saveCSVFile(
    BuildContext context,
    SaveDocumentState state,
    String fileName,
  ) async {
    try {
      var myCompany = await context.read<SaveDocumentCubit>().getMyCompany();

      List<List<String>> data = [];
      data.add([context.tr("menu_item_my_company")]);
      data.add([
        context.tr("field_my_company_name"),
        myCompany?.companyName ?? "",
      ]);
      data.add([
        context.tr("label_address"),
        myCompany?.address ?? "",
      ]);
      data.add(
        [context.tr("label_email"), myCompany?.email ?? ""],
      );
      data.add([
        context.tr("label_phone_number"),
        myCompany?.phone ?? "",
      ]);
      data.add(
        [context.tr("label_tax_id"), myCompany?.taxId ?? ""],
      );
      data.add([
        context.tr("label_bank_details"),
        myCompany?.bankDetails ?? "",
      ]);
      data.add([context.tr("document_information")]);
      data.add([
        context.tr("document_name_no"),
        state.name.value.toString(),
      ]);
      data.add([
        context.tr("field_date_time"),
        DateFormatFactory.getDateAndTimeFormat().format(state.date!),
      ]);
      data.add([
        context.tr("person_name"),
        state.personName ?? "",
      ]);
      data.add([
        context.tr("label_description"),
        state.description,
      ]);
      data.add([context.tr("goods")]);
      data.addAll(getTableData(state));

      String csv = Csv().encode(
        data.map((row) => List<dynamic>.from(row)).toList(),
      );

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);

      await file.writeAsString(csv);
      // Export via share dialog (iOS-compatible)
      final params = ShareParams(
        files: [XFile('${file.path}')],
      );
      await SharePlus.instance.share(params);
      ToastUtils.showSuccessToast(context.tr("csv_saved_and_shared"));
    } catch (e) {
      ToastUtils.showErrorToast(sprintf(context.tr("error_with_details"), [e.toString()]));
    }
  }

  Widget _buildEmptyTransaction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
      child: Column(
        children: [
          Icon(
            UIConstants.goodIconData,
            size: 64,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr("no_goods"),
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsView(BuildContext context, SaveDocumentState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.transactions.length,
        itemBuilder: (context, index) {
          final transaction = state.transactions[index];
          return DocumentTransactionItemRow(
            transaction,
            Colors.transparent,
            (item) => context
                .read<SaveDocumentCubit>()
                .onPressedTransaction(transaction),
            (item) => onLongPressedTransaction(transaction),
            false,
            AppSettings.getGoodPropertiesSettings(),
          );
        },
      ),
    );
  }

  void onLongPressedTransaction(
    DocumentTransaction item,
  ) {
    var items = [
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("delete")) {
          showDeleteDocumentConfirm(context, item);
        }
      },
    );
  }

  void showDeleteDocumentConfirm(
    BuildContext context,
    DocumentTransaction item,
  ) {
    showCustomAlertDialog(
      context,
      message: context.tr("message_confirm_delete_no_args"),
      onPositivePressed: () async {
        hideDialog(context);
        context.read<SaveDocumentCubit>().deleteTransaction(item);
      },
    );
  }
}
