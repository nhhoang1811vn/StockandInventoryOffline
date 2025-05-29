import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/save_document_setting.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/add_quantity_and_price/add_quantity_and_price_dialog.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../domain/entities/supplier.dart';
import '../../style_size.dart';
import '../../widgets/snackbar_widgets.dart';
import '../app_text_field.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'components/document_transaction_item_row.dart';
import 'components/sort_save_document_dialog.dart';

enum OverflowItemMenu { search, sortby, export, help }

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
  final TextEditingController searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    context.read<SaveDocumentCubit>().init(widget.item);
    personNameController.text = widget.item.personName ?? '';
    dateController.text = DateFormatFactory.getDateAndTimeFormat().format(widget.item.date);
    return BlocConsumer<SaveDocumentCubit, SaveDocumentState>(
        listener: (context, state) async {
          if (state.state is SaveDocumentFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailureWithText(state.exceptionError));
          } else if (state.state is SaveDocumentSuccessfulState) {
            final InAppReview inAppReview = InAppReview.instance;
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop();
          } else if (state.state is OpenPersonListState) {
            if (state.item?.type == DocumentType.incoming) {
              final result =
                  await Navigator.of(context).pushNamed(Pages.supplier_list, arguments: {"isSelection": true});
              if (result != null) {
                Supplier item = result as Supplier;
                context.read<SaveDocumentCubit>().onPersonNameChanged(item.name);
                context.read<SaveDocumentCubit>().onPersonChanged(item.id!);

                personNameController.text = item.name;
              }
            } else {
              final result =
                  await Navigator.of(context).pushNamed(Pages.customer_list, arguments: {"isSelection": true});
              if (result != null) {
                Customer item = result as Customer;
                context.read<SaveDocumentCubit>().onPersonNameChanged(item.name);
                context.read<SaveDocumentCubit>().onPersonChanged(item.id!);

                personNameController.text = item.name;
              }
            }
          } else if (state.state is OpenGoodListState) {
            await Navigator.of(context)
                .pushNamed(Pages.good_list, arguments: {"isSelection": true, "document": state.item});
            context.read<SaveDocumentCubit>().loadTransactions();
          } else if (state.state is OpenSaveGoodState) {
            final finalState = state.state as OpenSaveGoodState;
            final transaction = finalState.item;
            final result = await Navigator.of(context).pushNamed(Pages.save_good,
                arguments: {"item": transaction.good, "document": state.item, "transaction": transaction});
            if (result != null) {
              context.read<SaveDocumentCubit>().loadTransactions();
            }
          } else if (state.state is OpenBarcodeScannerPageState) {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ));
            if (result != "-1") {
              Utils.handleABarcodeFound();
              context.read<SaveDocumentCubit>().findGood(result);
            }
          } else if (state.state is OpenHelpPageState) {
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.documents_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.DOCUMENTS)
            });
          } else if (state.state is OpenSortDialogListState) {
            SaveDocumentSetting? setting = await showDialog(
                context: context, builder: (_) => SortSaveDocumentDialog(state.setting), barrierDismissible: true);
            if (setting != null) {
              context.read<SaveDocumentCubit>().setSettings(setting);
            }
          } else if (state.state is OpenSaveGoodPageWithBarcodeState) {
            final finalState = state.state as OpenSaveGoodPageWithBarcodeState;
            final barcode = finalState.barcode;
            final good = Good();
            good.name = barcode;
            good.barCode = barcode;
            good.storeId = storage.getSelectedStoreId();

            DocumentTransaction transaction = DocumentTransaction();
            transaction.quantity = 1;
            transaction.price = 0.0;
            transaction.type = widget.item.type;
            transaction.storeId = storage.getSelectedStoreId();

            final result = await Navigator.of(context).pushNamed(Pages.save_good,
                arguments: {"item": good, "document": state.item, "transaction": transaction});

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
                barrierDismissible: false);
            if (result != null){
              double quantity = result["quantity"] ?? 0;
              double price = result["price"] ?? 0.0;
              context.read<SaveDocumentCubit>().saveThenAddTransaction(good, quantity, price);
              context.read<SaveDocumentCubit>().onBatchScanMenuClicked();
            }
          } else if (state.state is OpenBarcodeScannerToSearchState) {
            //open bar code scanner to fill search text box
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ));
            if (result != "-1") {
              Utils.handleABarcodeFound();
              //searchTextController.text = result;
              context.read<SaveDocumentCubit>().onSearchTextChanged(result);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
            }
          }
        },
        listenWhen: (state1, state2) => state1.state != state2.state,
        builder: (context, state) => Scaffold(
              
              resizeToAvoidBottomInset: false,
              appBar: _buildAppBar(context, state),
              body: Column(
                children: [
                  SelectedStoreView(),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.document_information,
                            style: Theme.of(context).textTheme.titleMedium),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                AppTextField(
                                    labelText: AppLocalizations.of(context)!.field_document_no,
                                    hintText: AppLocalizations.of(context)!.hint_name,
                                    initialValue: state.name.value,
                                    onChanged: (value) => context.read<SaveDocumentCubit>().nameChanged(value),
                                    keyboardType: TextInputType.name,
                                    error: state.name.displayError?.text(context)),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child:  AppTextField(
                                        controller: personNameController,
                                        labelText: state.item?.type == DocumentType.incoming
                                            ? AppLocalizations.of(context)!.label_supplier_name
                                            : AppLocalizations.of(context)!.label_customer_name,
                                        hintText: AppLocalizations.of(context)!.hint_select,
                                        suffix: Icon(Icons.keyboard_arrow_down, size: 16,),
                                        keyboardType: TextInputType.none,
                                        readOnly: true,
                                        onTapped: () => {context.read<SaveDocumentCubit>().onPersonClicked()},
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Expanded(
                                        child: AppTextField(
                                      controller: dateController,
                                      labelText: AppLocalizations.of(context)!.field_date_time,
                                      keyboardType: TextInputType.datetime,
                                      readOnly: true,
                                      onTapped: () => {
                                        DatePicker.showDateTimePicker(context,
                                            locale: MyApp.getDatePickerLocaleType(context),
                                            showTitleActions: true,
                                            minTime: Config.minTime,
                                            maxTime: Config.maxTime,
                                            onChanged: (date) {}, onConfirm: (date) {
                                          context.read<SaveDocumentCubit>().dateChanged(date);
                                          dateController.text = DateFormatFactory.getDateAndTimeFormat().format(date);
                                        }, currentTime: state.date)
                                      },
                                    )),
                                  ],
                                ),
                                SizedBox(height: 16),
                                AppTextField(
                                    labelText: AppLocalizations.of(context)!.label_description,
                                    hintText: AppLocalizations.of(context)!.hint_description,
                                    maxLines: null,
                                    minLines: 2,
                                    initialValue: state.description,
                                    onChanged: (value) => context.read<SaveDocumentCubit>().descriptionChanged(value),
                                    keyboardType: TextInputType.name),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16,),
                        Text(AppLocalizations.of(context)!.goods_information,
                            style: Theme.of(context).textTheme.titleMedium),
                        _buildSearchBar(context, state),
                        Expanded(
                          child: Card(

                            child: Stack(
                              children: [
                                Visibility(
                                  child: _buildEmptyTransaction(context),
                                  visible: state.transactions.isEmpty,
                                ),
                                Visibility(
                                  child: _buildTransactionsView(context, state),
                                  visible: state.transactions.isNotEmpty,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 32,
                        color: Colors.blue,
                        child: IntrinsicHeight(
                            child: Row(
                          children: [
                            SizedBox(width: 16),
                            Text(state.transactions.length.toString(),
                                style: TextStyle(color: Colors.white, fontSize: TextSize.medium)),
                            SizedBox(width: 16),
                            VerticalDivider(width: 2, color: Colors.white),
                            SizedBox(width: 16),
                            Text(state.totalQuantity.toString(),
                                style: TextStyle(color: Colors.white, fontSize: TextSize.medium)),
                            SizedBox(width: 16),
                            VerticalDivider(width: 2, color: Colors.white),
                            SizedBox(width: 16),
                            Text(Config.currencyFormat.format(state.totalAmount),
                                style: TextStyle(color: Colors.white, fontSize: TextSize.medium)),
                          ],
                        )),
                      ))
                  //Expanded(child: SaveDocumentForm(item: widget.item, state: state,))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => context.read<SaveDocumentCubit>().onAddGoodClicked(),
              ),
            ));
  }

  PreferredSize _buildAppBar(BuildContext context, SaveDocumentState state) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(
            title: Text(widget.item.type == DocumentType.incoming
                ? AppLocalizations.of(context)!.incoming_document_text
                : AppLocalizations.of(context)!.outgoing_document_text),
            actions: <Widget>[
              _buildSaveMenu(context),
              _buildBatchScanMenu(context),
              PopupMenuButton<OverflowItemMenu>(
                itemBuilder: (context) => [
                  PopupMenuItem<OverflowItemMenu>(
                      value: OverflowItemMenu.search, child: Text(AppLocalizations.of(context)!.action_search)),
                  PopupMenuItem<OverflowItemMenu>(
                      value: OverflowItemMenu.sortby, child: Text(AppLocalizations.of(context)!.action_sort_by)),
                  PopupMenuItem<OverflowItemMenu>(
                      value: OverflowItemMenu.export, child: Text(AppLocalizations.of(context)!.action_export)),
                  PopupMenuItem<OverflowItemMenu>(
                      value: OverflowItemMenu.help, child: Text(AppLocalizations.of(context)!.action_help)),
                ],
                onSelected: (item) => handleClick(context, item, state),
              )
            ]));
  }

  void handleClick(BuildContext context, OverflowItemMenu item, SaveDocumentState state) {
    switch (item) {
      case OverflowItemMenu.search:
        context.read<SaveDocumentCubit>().onSearchMenuClicked();
        //search
        break;
      case OverflowItemMenu.sortby:
        context.read<SaveDocumentCubit>().onSortByMenuClicked();
        //sort by
        break;
      case OverflowItemMenu.export:
        onExport(state);
        //context.read<SaveDocumentCubit>().onExportMenuClicked();
        //sort by
        break;
      case OverflowItemMenu.help:
        context.read<SaveDocumentCubit>().onHelpMenuClicked();
        break;
      //help
    }
  }

  void onExport(SaveDocumentState state) async {
    String fileName = 'StockandInventory_Document_${state.name.value}.csv';
    await saveCSVFile(context, state, fileName);
  }

  Future<void> saveCSVFile(BuildContext context, SaveDocumentState state, String fileName) async {
    try {
      List<List<String>> data = [];
      data.add([AppLocalizations.of(context)?.document_name_no ?? "", state.name.value.toString()]);
      data.add([
        AppLocalizations.of(context)?.field_date_time ?? "",
        DateFormatFactory.getDateAndTimeFormat().format(state.date!)
      ]);
      data.add([AppLocalizations.of(context)?.field_person_name ?? "", state.personName ?? ""]);
      data.add([AppLocalizations.of(context)?.label_description ?? "", state.description]);
      data.add([AppLocalizations.of(context)?.goods_title ?? ""]);
      data.add([
        AppLocalizations.of(context)?.field_name ?? "",
        AppLocalizations.of(context)?.label_description ?? "",
        AppLocalizations.of(context)?.field_bar_code ?? "",
        AppLocalizations.of(context)?.field_quantity ?? ""
      ]);
      state.allTransactions.forEach((item) {
        data.add([item.good.name, item.good.description, item.good.barCode ?? "", item.quantity.toString()]);
      });

      String csv = const ListToCsvConverter().convert(data);

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);

      await file.writeAsString(csv);
      // Export via share dialog (iOS-compatible)
      final params = ShareParams(
        files: [XFile('${file.path}')],
      );
      await SharePlus.instance.share(params);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Save CSV Successful: ${file.path}'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Save CSV Failed: ${e.toString()}'),
      ));
    }
  }

  Widget _buildSaveMenu(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<SaveDocumentCubit>().onSaveMenuClicked();
        },
        icon: Icon(Icons.check));
  }

  Widget _buildBatchScanMenu(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<SaveDocumentCubit>().onBatchScanMenuClicked();
        },
        icon: Icon(Icons.barcode_reader));
  }

  Widget _buildEmptyTransaction(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(UIConstants.goodIconData, size: 64, color: Theme.of(context).colorScheme.primary),
          SizedBox(
            height: 16,
          ),
          Text(AppLocalizations.of(context)!.empty_goods,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTransactionsView(BuildContext context, SaveDocumentState state) {
    return ListView.builder(
        itemBuilder: (BuildContext context, index) {
          var transaction = state.transactions[index];
          return DocumentTransactionItemRow(
              transaction,
              (item) => context.read<SaveDocumentCubit>().onPressedTransaction(transaction),
              (item) => onLongPressedTransaction(context, transaction));
        },
        itemCount: state.transactions.length);
  }

  void onLongPressedTransaction(BuildContext context, DocumentTransaction item) {
    showDialog(
        context: context,
        builder: (BuildContext a) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteDocumentConfirm(context, item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }
  void showDeleteDocumentConfirm(BuildContext context, DocumentTransaction item) {
    showDialog(
        context: context,
        builder: (BuildContext contextaaa) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(AppLocalizations.of(context)!.message_confirm_delete_no_args),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<SaveDocumentCubit>().deleteTransaction(item);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }
  Widget _buildSearchBar(BuildContext context, SaveDocumentState state) {
    return Visibility(
        child: Card(
          child: ListTile(
            title: TextField(
              controller: searchTextController,
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.action_search, border: InputBorder.none),
              onChanged: context.read<SaveDocumentCubit>().onSearchTextChanged,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  child: IconButton(
                    icon: Icon(UIConstants.cancelIconData),
                    onPressed: () {
                      searchTextController.text = "";
                      context.read<SaveDocumentCubit>().resetSearchText();
                    },
                  ),
                  visible: state.textSearch.isNotEmpty,
                ),
                IconButton(
                  icon: Image.asset(
                    UIConstants.searchBarcodeIconPath,
                    width: 24,
                  ),
                  onPressed: context.read<SaveDocumentCubit>().onSearchBarcodeClicked,
                )
              ],
            ),
          ),
        ),
        visible: state.showSearchBar);
  }
}
