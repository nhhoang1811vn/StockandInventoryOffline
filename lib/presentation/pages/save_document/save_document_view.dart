import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/payment_status.dart';
import 'package:good_manager/domain/entities/save_document_setting.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/add_quantity_and_price/add_quantity_and_price_dialog.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../domain/entities/supplier.dart';
import '../../widgets/snackbar_widgets.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'components/save_document_form.dart';
import 'components/select_payment_status_dialog.dart';
import 'components/sort_save_document_dialog.dart';
enum OverflowItemMenu { search, sortby, help }

class SaveDocumentPage extends StatelessWidget {
  final Document item;

  SaveDocumentPage(this.item) : super();
  @override
  Widget build(BuildContext context) {
    context.read<SaveDocumentCubit>().init(item);
    return BlocConsumer<SaveDocumentCubit, SaveDocumentState>(
        listener: (context, state) async {
          if (state.state is SaveDocumentFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailureWithText(state.exceptionError));
          } else if (state.state is SaveDocumentSuccessfulState) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop();
          } else if (state.state is OpenPersonListState) {
            if (state.item?.type == DocumentType.incoming){
              final result = await Navigator.of(context).pushNamed(Pages.supplier_list, arguments: {"isSelection": true});
              if (result != null) {
                Supplier item = result as Supplier;
                context.read<SaveDocumentCubit>().onPersonNameChanged(item.name);
                context.read<SaveDocumentCubit>().onPersonChanged(item.id!);
              }
            }else{
              final result = await Navigator.of(context).pushNamed(Pages.customer_list, arguments: {"isSelection": true});
              if (result != null) {
                Customer item = result as Customer;
                context.read<SaveDocumentCubit>().onPersonNameChanged(item.name);
                context.read<SaveDocumentCubit>().onPersonChanged(item.id!);
              }
            }

          }else if (state.state is OpenGoodListState) {
            await Navigator.of(context).pushNamed(Pages.good_list,
                arguments: {"isSelection": true, "document": state.item});
            context.read<SaveDocumentCubit>().loadTransactions();
          } else if (state.state is OpenSaveGoodState) {
            final finalState = state.state as OpenSaveGoodState;
            final transaction = finalState.item;
            final result = await Navigator.of(context)
                .pushNamed(Pages.save_good, arguments: {
                  "item": transaction.good,
                  "document": state.item,
                  "transaction": transaction});
            if (result != null) {
              context.read<SaveDocumentCubit>().loadTransactions();
            }
          }else if (state.state is OpenBarcodeScannerPageState){
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ));
            if (result != "-1"){
              Utils.handleABarcodeFound();
              context.read<SaveDocumentCubit>().findGood(result);
            }
          }else if (state.state is OpenHelpPageState){
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.documents_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.DOCUMENTS)
            });
          }else if (state.state is OpenSortDialogListState){
            SaveDocumentSetting? setting = await showDialog(
                context: context,
                builder: (_) => SortSaveDocumentDialog(state.setting),
                barrierDismissible: true);
            if (setting != null){
              context.read<SaveDocumentCubit>().setSettings(setting);
            }
          }else if (state.state is OpenSaveGoodPageWithBarcodeState){
            final finalState = state.state as OpenSaveGoodPageWithBarcodeState;
            final barcode = finalState.barcode;
            final good = Good();
            good.name = barcode;
            good.barCode = barcode;
            good.storeId = storage.getSelectedStoreId();

            DocumentTransaction transaction = DocumentTransaction();
            transaction.quantity = 1;
            transaction.price = 0.0;
            transaction.type = item.type;
            transaction.storeId = storage.getSelectedStoreId();

            final result = await Navigator.of(context)
                .pushNamed(Pages.save_good, arguments: {
                  "item": good,
                  "document": state.item,
                  "transaction": transaction
                });

            if (result != null) {
              Map data = result as Map<dynamic, dynamic>;
              Document document = data['document'] as Document;
              context.read<SaveDocumentCubit>().updateDocument(document);
              context.read<SaveDocumentCubit>().loadTransactions();
              context.read<SaveDocumentCubit>().onBatchScanMenuClicked();
            }
          }else if (state.state is OpenInputQuantityDialogState){
            final finalState = state.state as OpenInputQuantityDialogState;
            final good = finalState.good;
            Map<dynamic, dynamic> result = await showDialog(
                context: context,
                builder: (_) => AddQuantityAndPriceWidget(good, item.type),
                barrierDismissible: true);
            double quantity = result["quantity"] ?? 0;
            double price = result["price"] ?? 0.0;
            context.read<SaveDocumentCubit>().saveThenAddTransaction(good, quantity, price);
            context.read<SaveDocumentCubit>().onBatchScanMenuClicked();

          }else if (state.state is OpenBarcodeScannerToSearchState){
            //open bar code scanner to fill search text box
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ));
            if (result != "-1"){
              Utils.handleABarcodeFound();
              //searchTextController.text = result;
              context.read<SaveDocumentCubit>().onSearchTextChanged(result);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));

            }
          }else if (state.state is OpenChangePaymentDialogState){
            PaymentStatus? status = await showDialog(
                context: context,
                builder: (_) => SelectPaymentStatusDialog(state.paymentStatus!),
                barrierDismissible: true);
            if (status != null){
              if (status == PaymentStatus.PAID || status == PaymentStatus.UNPAID){
                context.read<SaveDocumentCubit>().onPaymentStatusChanged(status);
                context.read<SaveDocumentCubit>().save();
              }else{
                final saveResult = await context.read<SaveDocumentCubit>().save();
                if (saveResult){
                  await Navigator.of(context).pushNamed(Pages.payment_list, arguments: {"documentId": state.item!.id!});
                  context.read<SaveDocumentCubit>().loadPaymentsAndCheck();
                }
              }

            }
          }else if (state.state is OpenPaymentListPageState){
            await Navigator.of(context).pushNamed(Pages.payment_list, arguments: {"documentId": state.item!.id!});
            context.read<SaveDocumentCubit>().loadPaymentsAndCheck();
          }
        },
        listenWhen: (state1, state2) => state1.state != state2.state,
        builder: (context, state) =>
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _buildAppBar(context, state),
              body: Column(children: [
                SelectedStoreView(),
                Expanded(child: SaveDocumentForm(item: item, state: state,))
              ],),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => context.read<SaveDocumentCubit>().onAddGoodClicked(),
              ),
            )
    );
  }
  PreferredSize _buildAppBar(BuildContext context, SaveDocumentState state){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(item.type == DocumentType.incoming? AppLocalizations.of(context)!.incoming_document_text:AppLocalizations.of(context)!.outgoing_document_text),
        actions: <Widget>[
          _buildSaveMenu(context),
          _buildBatchScanMenu(context),
          PopupMenuButton<OverflowItemMenu>(itemBuilder: (context) => [
            PopupMenuItem<OverflowItemMenu>(value: OverflowItemMenu.search, child: Text(AppLocalizations.of(context)!.action_search)),
            PopupMenuItem<OverflowItemMenu>(value: OverflowItemMenu.sortby, child: Text(AppLocalizations.of(context)!.action_sort_by)),
            PopupMenuItem<OverflowItemMenu>(value: OverflowItemMenu.help, child: Text(AppLocalizations.of(context)!.action_help)),
          ],
            onSelected: (item) => handleClick(context,item),
          )

        ]));
  }
  void handleClick(BuildContext context, OverflowItemMenu item){
    switch (item) {
      case OverflowItemMenu.search:
        context.read<SaveDocumentCubit>().onSearchMenuClicked();
        //search
        break;
      case OverflowItemMenu.sortby:
        context.read<SaveDocumentCubit>().onSortByMenuClicked();
        //sort by
        break;
      case OverflowItemMenu.help:
        context.read<SaveDocumentCubit>().onHelpMenuClicked();
        break;
        //help
    }
  }
  Widget _buildSaveMenu(BuildContext context){
    return IconButton(onPressed: (){
      context.read<SaveDocumentCubit>().onSaveMenuClicked();
    }, icon: Icon(Icons.check));
  }
  Widget _buildBatchScanMenu(BuildContext context){
    return IconButton(onPressed: (){
      context.read<SaveDocumentCubit>().onBatchScanMenuClicked();
    }, icon: Icon(Icons.barcode_reader));
  }
}
