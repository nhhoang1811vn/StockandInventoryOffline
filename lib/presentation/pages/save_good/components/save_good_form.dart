import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/base/insufficient_stock_message.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';
import 'package:good_manager/presentation/pages/save_good/components/quick_insert_document_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/util/entity_image_picker.dart';
import 'package:good_manager/util/quantity_format.dart';
import 'package:good_manager/util/quantity_input.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../presentation/widget/widget.dart';
import '../../../../util/util.dart';
import '../../../dialog/dialog.dart';
import '../../../review_manager.dart';

class SaveGoodForm extends StatelessWidget {
  SaveGoodForm();

  final quantityTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final barcodeTextController = TextEditingController();

  final purchasePriceTextController = TextEditingController();
  final salePriceTextController = TextEditingController();
  final minQuantityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveGoodCubit, SaveGoodState>(
      listenWhen: (state1, state2) {
        return state1.state != state2.state;
      },
      listener: (BuildContext context, SaveGoodState state) async {
        if (state.state is InsufficientStockError) {
          ToastUtils.showErrorToast(insufficientStockMessage(
            (state.state as InsufficientStockError).error,
            AppSettings.getQuantityDecimals(),
            context.tr,
          ));
        } else if (state.state is SaveItemSameBarcodeError) {
          ToastUtils.showErrorToast(context.tr("error_duplicate_barcode"));
        } else if (state.state is SaveItemError) {
          ToastUtils.showErrorToast(context.tr("snackbar_try_again"));
        } else if (state.state is SaveItemSuccessful) {
          ReviewManager.maybeRequestReview();
          ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
          Navigator.of(context)
              .pop({"item": state.item, "document": state.document});
        } else if (state.state is OpenCalculatorToInputQuantityState) {
          showCalculatorPopup(context, state.transaction!.quantity.toDouble(),
              (p0) {
            final text =
                calculatorQuantityText(p0, AppSettings.getQuantityDecimals());
            context.read<SaveGoodCubit>().quantityChanged(text);
            quantityTextController.text = text;
          });
        } else if (state.state is OpenCalculatorToInputPriceState) {
          showCalculatorPopup(context, state.transaction!.price, (p0) {
            NumberFormat format = new NumberFormat("0.#");
            context.read<SaveGoodCubit>().onPriceChanged(format.format(p0));
            priceTextController.text = Config.simpleCurrencyFormat.format(p0);
          });
        } else if (state.state is OpenCalculatorToInputPurchasePriceState) {
          showCalculatorPopup(context, state.purchasePrice, (p0) {
            NumberFormat format = new NumberFormat("0.#");
            context
                .read<SaveGoodCubit>()
                .onPurchasePriceChanged(format.format(p0));
            purchasePriceTextController.text =
                Config.simpleCurrencyFormat.format(p0);
          });
        } else if (state.state is OpenCalculatorToInputSalePriceState) {
          showCalculatorPopup(context, state.salePrice, (p0) {
            NumberFormat format = new NumberFormat("0.#");
            context.read<SaveGoodCubit>().onSalePriceChanged(format.format(p0));
            salePriceTextController.text =
                Config.simpleCurrencyFormat.format(p0);
          });
        } else if (state.state is OpenBarcodeScannerPageState) {
          var result = await Utils.scanBarcode(context);
          if (result != null) {
            context.read<SaveGoodCubit>().barCodeChanged(result);
          }
        } else if (state.state is OpenHistoryPageState) {
          Navigator.of(context).pushNamed(
            Pages.good_history,
            arguments: {'goodId': state.item!.id},
          );
        } else if (state.state is OpenReceiveGoodsPopupState) {
          //quick insert document +
          Map<dynamic, dynamic>? result = await showDialog(
            context: context,
            builder: (_) =>
                QuickInsertDocumentWidget(state.item!, DocumentType.incoming),
            barrierDismissible: true,
          );
          if (result != null) {
            saveTransaction(context, DocumentType.incoming, state, result);
          }
        } else if (state.state is OpenIssueGoodsPopupState) {
          //quick insert document -
          Map<dynamic, dynamic>? result = await showDialog(
            context: context,
            builder: (_) =>
                QuickInsertDocumentWidget(state.item!, DocumentType.outgoing),
            barrierDismissible: true,
          );
          if (result != null) {
            saveTransaction(context, DocumentType.outgoing, state, result);
          }
        }
      },
      builder: (context, state) {
        barcodeTextController.text = state.barCode;
        if (state.transaction?.price != null) {
          priceTextController.text =
              Config.simpleCurrencyFormat.format(state.transaction?.price);
        } else {
          priceTextController.text = "";
        }
        if (state.purchasePrice != null) {
          purchasePriceTextController.text =
              Config.simpleCurrencyFormat.format(state.purchasePrice);
        } else {
          purchasePriceTextController.text = "";
        }
        if (state.salePrice != null) {
          salePriceTextController.text =
              Config.simpleCurrencyFormat.format(state.salePrice);
        } else {
          salePriceTextController.text = "";
        }
        // Rewrite the field only when it no longer stands for the value, so a
        // half-typed "2." keeps its dot.
        if (!quantityTextMatches(
            minQuantityTextController.text, state.minQuantity)) {
          minQuantityTextController.text = state.minQuantity == null
              ? ""
              : formatQuantity(
                  state.minQuantity!, AppSettings.getQuantityDecimals());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (state.showImage) ...[
              Center(
                child: EntityPhotoAvatar(
                  imageBytes: state.files.firstOrNull,
                  fallbackIcon: Icons.inventory_2_rounded,
                  canEdit: true,
                  onTap: () {
                    EntityImagePicker.showSourceSheet(
                      context,
                      onImagePicked: (bytes) async {
                        context.read<SaveGoodCubit>().onLogoChanged(bytes);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
            AppTextField(
              labelText: context.tr("label_good_name"),
              hintText: context.tr("hint_name"),
              initialValue: state.name.value,
              onChanged: (value) =>
                  context.read<SaveGoodCubit>().nameChanged(value),
              keyboardType: TextInputType.name,
              error: state.name.displayError?.text(context),
            ),
            SizedBox(
              height: 16,
            ),
            if (state.showDescription) ...[
              AppTextField(
                labelText: context.tr("label_description"),
                hintText: context.tr("hint_description"),
                maxLines: null,
                minLines: 2,
                initialValue: state.description,
                onChanged: (value) =>
                    context.read<SaveGoodCubit>().descriptionChanged(value),
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: 16,
              ),
            ],
            if (state.showBarcode) ...[
              _buildBarCode(context, state),
              SizedBox(height: 16),
            ],
            if (state.transaction == null)
              Column(
                children: [
                  if (state.showPurchasePrice || state.showSalePrice) ...[
                    Row(
                      children: [
                        if (state.showPurchasePrice)
                          Expanded(child: _buildPurchasePrice(context, state)),
                        if (state.showSalePrice)
                          Expanded(child: _buildSalePrice(context, state)),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                  Row(
                    children: [
                      Expanded(child: _buildQuantity(context, state, true)),
                      CircleButton(
                        FontAwesomeIcons.plus.data,
                        context
                            .read<SaveGoodCubit>()
                            .onPlusQuantityButtonPressed,
                      ),
                      CircleButton(
                        FontAwesomeIcons.minus.data,
                        context
                            .read<SaveGoodCubit>()
                            .onMinusQuantityButtonPressed,
                      ),
                    ],
                  ),
                ],
              ),
            if (state.transaction != null)
              Row(
                children: [
                  Expanded(
                    child: _buildQuantity(context, state, false),
                  ),
                  if (state.transaction!.type == DocumentType.incoming
                      ? state.showPurchasePrice
                      : state.showSalePrice)
                    Expanded(child: _buildPrice(context, state)),
                ],
              ),
            SizedBox(
              height: 16,
            ),
            if (state.showMinQuantity)
              AppTextField(
                labelText: context.tr("min_quantity"),
                hintText: context.tr("min_quantity"),
                controller: minQuantityTextController,
                onChanged: (value) =>
                    context.read<SaveGoodCubit>().onMinQuantityChanged(value),
                keyboardType: quantityKeyboardType(),
                inputFormatter: quantityInputFormatters(),
              ),
            SizedBox(
              height: 16,
            ),
            if (state.showImage)
              ImagesInformationSection(
                files: state.files,
                canEdit: true,
                onAddFile: (bytes) =>
                    context.read<SaveGoodCubit>().onAddFile(bytes),
                onDeleteFile: (index) =>
                    context.read<SaveGoodCubit>().onDeleteFile(index),
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
            labelText: context.tr("label_bar_code"),
            hintText: context.tr("hint_bar_code"),
            onChanged: (value) =>
                context.read<SaveGoodCubit>().barCodeChanged(value),
            keyboardType: TextInputType.text,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: CircleButton(
            Icons.barcode_reader,
            context.read<SaveGoodCubit>().onBarcodeScannerPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantity(
    BuildContext context,
    SaveGoodState state,
    bool readonly,
  ) {
    quantityTextController.text =
        StringUtils.getQuantityText(state.item!.quantity);
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            readOnly: readonly,
            labelText: context.tr("quantity"),
            keyboardType: quantityKeyboardType(),
            inputFormatter: quantityInputFormatters(),
            onChanged: (value) =>
                context.read<SaveGoodCubit>().quantityChanged(value),
            controller: quantityTextController,
          ),
        ),
        if (!readonly)
          Align(
            alignment: Alignment.centerRight,
            child: CircleButton(
              FontAwesomeIcons.calculator.data,
              context.read<SaveGoodCubit>().onQuantityCalculatorPressed,
            ),
          ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: state.transaction?.type == DocumentType.incoming
                ? context.tr("purchase_price")
                : context.tr("sale_price"),
            controller: priceTextController,
            onChanged: context.read<SaveGoodCubit>().onPriceChanged,
          ),
        ),
        CircleButton(
          FontAwesomeIcons.calculator.data,
          context.read<SaveGoodCubit>().onPriceCalculatorPressed,
        ),
      ],
    );
  }

  Widget _buildPurchasePrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: context.tr("purchase_price"),
            controller: purchasePriceTextController,
            onChanged: context.read<SaveGoodCubit>().onPurchasePriceChanged,
          ),
        ),
        CircleButton(
          FontAwesomeIcons.calculator.data,
          context.read<SaveGoodCubit>().onPurchasePriceCalculatorPressed,
        ),
      ],
    );
  }

  Widget _buildSalePrice(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: context.tr("sale_price"),
            controller: salePriceTextController,
            onChanged: context.read<SaveGoodCubit>().onSalePriceChanged,
          ),
        ),
        CircleButton(
          FontAwesomeIcons.calculator.data,
          context.read<SaveGoodCubit>().onSalePriceCalculatorPressed,
        ),
      ],
    );
  }

  Future<void> saveTransaction(
    BuildContext context,
    DocumentType type,
    SaveGoodState state,
    Map result,
  ) async {
    int storeId = context.read<SaveGoodCubit>().getSelectedStoreId();

    // Check the stock first: a rejected issue must not create a Document.
    final allowed = await context
        .read<SaveGoodCubit>()
        .canQuickInsert(type, result["quantity"] ?? 0.0);
    if (!allowed) return;

    Document document = Document();
    document.storeId = storeId;
    document.type = type;
    document.name = context.tr("document_name_no") +
        context.read<SaveGoodCubit>().getAutoDocumentNo(storeId).toString();
    document.date = result["date"] ?? DateTime.now();
    document.description = result["description"] ?? "";
    document.personId = result["personId"] ?? null;

    int documentId =
        await context.read<SaveGoodCubit>().insertDocument(document);

    DocumentTransaction transaction = DocumentTransaction();
    transaction.storeId = storeId;
    transaction.documentId = documentId;
    transaction.goodId = state.item!.id!;
    transaction.type = type;
    transaction.quantity = result["quantity"] ?? 0.0;
    transaction.price = result["price"] ?? 0.0;

    final inserted =
        await context.read<SaveGoodCubit>().insertTransaction(transaction);
    if (!inserted) return;
    if (type == DocumentType.incoming) {
      context.read<SaveGoodCubit>().updateQuantity(transaction.quantity);
    } else {
      context.read<SaveGoodCubit>().updateQuantity(-transaction.quantity);
    }

    var text = sprintf(
      context.tr("action_document_created_withname"),
      [
        AppSettings.getDocumentPropertiesSettings()
            .displayName(document, context.tr)
      ],
    );
    ToastUtils.showSuccessToast(text);
  }
}
