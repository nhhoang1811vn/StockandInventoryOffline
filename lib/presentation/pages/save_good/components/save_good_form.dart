import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';
import 'package:good_manager/presentation/pages/save_good/components/quick_insert_document_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../domain/entities/good.dart';
import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../../widgets/images_preview/images_preview_view.dart';
import '../../currency_app_text_field.dart';

class SaveGoodForm extends StatelessWidget {
  SaveGoodForm();

  
  final quantityTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final barcodeTextController = TextEditingController();

  final purchasePriceTextController = TextEditingController();
  final salePriceTextController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveGoodCubit, SaveGoodState>(
      listenWhen: (state1, state2) {
        return state1.state != state2.state;
      },
      listener: (BuildContext context, SaveGoodState state) async {
      if (state.state is SaveItemError) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
      } else if (state.state is SaveItemSameBarcodeError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWhenFailureWithText(AppLocalizations.of(context)!.error_same_barcode));
      } else if (state.state is SaveItemSuccessful) {
        // final InAppReview inAppReview = InAppReview.instance;
        // if (await inAppReview.isAvailable()) {
        //   inAppReview.requestReview();
        // }
        ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
        Navigator.of(context).pop({"item": state.item, "document": state.document});
      } else if (state.state is OpenCalculatorToInputQuantityState) {
        Utils.showCalculatorPopup(context, state.transaction!.quantity.toDouble(), (p0) {
          context.read<SaveGoodCubit>().quantityChanged(p0.toInt().toString());
          quantityTextController.text = p0.toInt().toString();
        });
      } else if (state.state is OpenCalculatorToInputPriceState) {
        Utils.showCalculatorPopup(context, state.transaction!.price, (p0) {
          NumberFormat format = new NumberFormat("0.#");
          context.read<SaveGoodCubit>().onPriceChanged(format.format(p0));
          priceTextController.text = Config.simpleCurrencyFormat.format(p0);
        });
      } else if (state.state is OpenCalculatorToInputPurchasePriceState) {
        Utils.showCalculatorPopup(context, state.purchasePrice, (p0) {
          NumberFormat format = new NumberFormat("0.#");
          context.read<SaveGoodCubit>().onPurchasePriceChanged(format.format(p0));
          purchasePriceTextController.text = Config.simpleCurrencyFormat.format(p0);
        });
      } else if (state.state is OpenCalculatorToInputSalePriceState) {
        Utils.showCalculatorPopup(context, state.salePrice, (p0) {
          NumberFormat format = new NumberFormat("0.#");
          context.read<SaveGoodCubit>().onSalePriceChanged(format.format(p0));
          salePriceTextController.text = Config.simpleCurrencyFormat.format(p0);
        });
      } else if (state.state is OpenBarcodeScannerPageState) {
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SimpleBarcodeScannerPage(),
            ));
        if (result != "-1") {
          Utils.handleABarcodeFound();
          //barcodeTextController.text = result;
          context.read<SaveGoodCubit>().barCodeChanged(result);
        }
      }else if (state.state is OpenHistoryPageState){
        Navigator.of(context).pushNamed(Pages.good_history, arguments: {'goodId': state.item!.id});
      }  else if (state.state is OpenReceiveGoodsPopupState) {
        //quick insert document +
        Map<dynamic, dynamic>? result = await showDialog(
            context: context,
            builder: (_) => QuickInsertDocumentWidget(state.item!, DocumentType.incoming),
            barrierDismissible: true);
        if (result != null) {
          saveTransaction(context, DocumentType.incoming, state, result);
        }
      } else if (state.state is OpenIssueGoodsPopupState) {
        //quick insert document -
        Map<dynamic, dynamic>? result = await showDialog(
            context: context,
            builder: (_) => QuickInsertDocumentWidget(state.item!, DocumentType.outgoing),
            barrierDismissible: true);
        if (result != null) {
          saveTransaction(context, DocumentType.outgoing, state, result);
        }
      }
    },
      builder: (context, state){
        barcodeTextController.text = state.barCode ?? '';
        if (state.transaction?.price != null) {
          priceTextController.text = Config.simpleCurrencyFormat.format(state.transaction?.price);
        } else {
          priceTextController.text = "";
        }
        if (state.purchasePrice != null) {
          purchasePriceTextController.text = Config.simpleCurrencyFormat.format(state.purchasePrice);
        } else {
          purchasePriceTextController.text = "";
        }
        if (state.salePrice != null) {
          salePriceTextController.text = Config.simpleCurrencyFormat.format(state.salePrice);
        } else {
          salePriceTextController.text = "";
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppTextField(
                labelText: AppLocalizations.of(context)!.label_good_name,
                hintText: AppLocalizations.of(context)!.hint_name,
                initialValue: state.name.value,
                onChanged: (value) => context.read<SaveGoodCubit>().nameChanged(value),
                keyboardType: TextInputType.name,
                error: state.name.displayError?.text(context)
            ),
            SizedBox(
              height: 16,
            ),
            AppTextField(
                labelText: AppLocalizations.of(context)!.label_description,
                hintText: AppLocalizations.of(context)!.hint_description,
                maxLines: null,
                minLines: 2,
                initialValue: state.description,
                onChanged: (value) => context.read<SaveGoodCubit>().descriptionChanged(value),
                keyboardType: TextInputType.name),
            SizedBox(
              height: 16,
            ),
            _buildBarCode(context, state),
            SizedBox(height: 16),
            if (state.transaction == null)
              Column(children: [
                Row(children: [
                  Expanded(child: _buildPurchasePrice(context, state)),
                  Expanded(child: _buildSalePrice(context, state))
                ]),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(child: _buildQuantity(context, state, true)),
                    CircleButton(FontAwesomeIcons.plus, context.read<SaveGoodCubit>().onPlusQuantityButtonPressed),
                    CircleButton(FontAwesomeIcons.minus, context.read<SaveGoodCubit>().onMinusQuantityButtonPressed),
                  ],
                ),
              ]),
            if (state.transaction != null)
              Row(
                children: [
                  Expanded(
                    child: _buildQuantity(context, state, false),
                  ),
                  Expanded(child: _buildPrice(context, state))
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildBarCode(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
              //initialValue: state.barCode,
              controller: barcodeTextController,
              labelText: AppLocalizations.of(context)!.label_bar_code,
              hintText: AppLocalizations.of(context)!.hint_bar_code,
              onChanged: (value) => context.read<SaveGoodCubit>().barCodeChanged(value),
              keyboardType: TextInputType.text),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: CircleButton(Icons.barcode_reader, context.read<SaveGoodCubit>().onBarcodeScannerPressed))
      ],
    );
  }

  Widget _buildQuantity(BuildContext context, SaveGoodState state, bool readonly) {
    quantityTextController.text = Utils.getQuantityText(state.item!.quantity);
    return Row(
      children: [
        Expanded(
            child: AppTextField(
              readOnly: readonly,
              labelText: AppLocalizations.of(context)!.field_quantity,
              keyboardType: TextInputType.number,
              onChanged: (value) => context.read<SaveGoodCubit>().quantityChanged(value),
              controller: quantityTextController,
            )),
        if (!readonly)
          Align(
              alignment: Alignment.centerRight,
              child:
              CircleButton(FontAwesomeIcons.calculator, context.read<SaveGoodCubit>().onQuantityCalculatorPressed))
      ],
    );
  }

  Widget _buildPrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
            child: CurrencyAppTextField(
              labelText: state.transaction?.type == DocumentType.incoming
                  ? AppLocalizations.of(context)!.field_purchase_price
                  : AppLocalizations.of(context)!.field_sale_price,
              controller: priceTextController,
              onChanged: context.read<SaveGoodCubit>().onPriceChanged,
            )),
        CircleButton(FontAwesomeIcons.calculator, context.read<SaveGoodCubit>().onPriceCalculatorPressed)
      ],
    );
  }

  Widget _buildPurchasePrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
            child: CurrencyAppTextField(
              labelText: AppLocalizations.of(context)!.field_purchase_price,
              controller: purchasePriceTextController,
              onChanged: context.read<SaveGoodCubit>().onPurchasePriceChanged,
            )),
        CircleButton(FontAwesomeIcons.calculator, context.read<SaveGoodCubit>().onPurchasePriceCalculatorPressed)
      ],
    );
  }

  Widget _buildSalePrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
            child: CurrencyAppTextField(
              labelText: AppLocalizations.of(context)!.field_sale_price,
              controller: salePriceTextController,
              onChanged: context.read<SaveGoodCubit>().onSalePriceChanged,
            )),
        CircleButton(FontAwesomeIcons.calculator, context.read<SaveGoodCubit>().onSalePriceCalculatorPressed)
      ],
    );
  }

  saveTransaction(BuildContext context, DocumentType type, SaveGoodState state, Map result) async {
    int storeId = storage.getSelectedStoreId();

    Document document = Document();
    document.storeId = storeId;
    document.type = type;
    document.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    document.date = result["date"] ?? DateTime.now();
    document.description = result["description"] ?? "";
    document.personId = result["personId"] ?? null;

    int documentId = await context.read<SaveGoodCubit>().insertDocument(document);

    DocumentTransaction transaction = DocumentTransaction();
    transaction.storeId = storeId;
    transaction.documentId = documentId;
    transaction.goodId = state.item!.id!;
    transaction.type = type;
    transaction.quantity = result["quantity"] ?? 0.0;
    transaction.price = result["price"] ?? 0.0;

    context.read<SaveGoodCubit>().insertTransaction(transaction);
    if (type == DocumentType.incoming) {
      context.read<SaveGoodCubit>().updateQuantity(transaction.quantity);
    } else {
      context.read<SaveGoodCubit>().updateQuantity(-transaction.quantity);
    }

    var text = sprintf(AppLocalizations.of(context)!.action_document_created_withname, [document.name]);
    ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccessWithText(text));
  }

}
