import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../domain/entities/good.dart';
import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../../widgets/images_preview/images_preview_view.dart';
import '../../currency_app_text_field.dart';

class SaveGoodForm extends StatelessWidget {
  final Good item;
  final DocumentTransaction? transaction;
  final quantityTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final barcodeTextController = TextEditingController();

  final purchasePriceTextController = TextEditingController();
  final salePriceTextController = TextEditingController();

  SaveGoodForm({Key? key, required this.item, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    quantityTextController.text = transaction?.quantity.toString() ?? '';
    priceTextController.text = Config.simpleCurrencyFormat.format(transaction?.price ?? 0.0); // transaction.pric
    barcodeTextController.text = item.barCode ?? '';
    purchasePriceTextController.text = Config.simpleCurrencyFormat.format(item.purchasePrice);
    salePriceTextController.text = Config.simpleCurrencyFormat.format(item.salePrice);
    return BlocConsumer<SaveGoodCubit, SaveGoodState>(
        listenWhen: (state1, state2) {
          return state1.state != state2.state;
        },
        listener: (context, state) async {
          if (state.state is SaveItemError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
          } else if (state.state is SaveItemSameBarcodeError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBarWhenFailureWithText(AppLocalizations.of(context)!.error_same_barcode));
          } else if (state.state is SaveItemSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop({"item": state.item, "document": state.document});
          } else if (state.state is OpenCalculatorToInputQuantityState) {
            Utils.showCalculatorPopup(context, state.transaction!.quantity.toDouble(), (p0){
              context.read<SaveGoodCubit>().quantityChanged(p0.toInt().toString());
              quantityTextController.text = p0.toInt().toString();
            });
          } else if (state.state is OpenCalculatorToInputPriceState){
            Utils.showCalculatorPopup(context, state.transaction!.price, (p0){
              NumberFormat format = new NumberFormat("0.#");
              context.read<SaveGoodCubit>().onPriceChanged(format.format(p0));
              priceTextController.text = Config.simpleCurrencyFormat.format(p0);
            });
          } else if (state.state is OpenCalculatorToInputPurchasePriceState){
            Utils.showCalculatorPopup(context, state.purchasePrice, (p0){
              NumberFormat format = new NumberFormat("0.#");
              context.read<SaveGoodCubit>().onPurchasePriceChanged(format.format(p0));
              purchasePriceTextController.text = Config.simpleCurrencyFormat.format(p0);
            });
          }else if (state.state is OpenCalculatorToInputSalePriceState){
            Utils.showCalculatorPopup(context, state.salePrice, (p0){
              NumberFormat format = new NumberFormat("0.#");
              context.read<SaveGoodCubit>().onSalePriceChanged(format.format(p0));
              salePriceTextController.text = Config.simpleCurrencyFormat.format(p0);
            });
          }
          else if (state.state is OpenBarcodeScannerPageState) {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ));
            if (result != "-1") {
              barcodeTextController.text = result;
              context.read<SaveGoodCubit>().barCodeChanged(result);
            }
          }
        },
        builder: (context, state) => SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppTextField(
                      labelText: AppLocalizations.of(context)!.field_name,
                      initialValue: state.name.value,
                      onChanged: (value) => context.read<SaveGoodCubit>().nameChanged(value),
                      keyboardType: TextInputType.name,
                      error: state.name.displayError?.text(context)),
                  AppTextField(
                      labelText: AppLocalizations.of(context)!.field_desc,
                      initialValue: state.description,
                      onChanged: (value) => context.read<SaveGoodCubit>().descriptionChanged(value),
                      keyboardType: TextInputType.name),
                  _buildBarCode(context, state),
                  SizedBox(height: 12),
                  if (transaction == null)
                    Row(children: [
                      Expanded(child:  _buildPurchasePrice(context, state)),
                      Expanded(child:  _buildSalePrice(context, state))
                    ],),
                  if (transaction != null)
                    Row(children: [
                      Expanded(child:  _buildQuantity(context, state),),
                      Expanded(child:  _buildPrice(context, state))
                    ],),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.field_images,
                      style: TextStyle(color: AppColors.secondaryColor, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 12),
                  ImagesPreviewView(state.files, true, context.read<SaveGoodCubit>().onImagesChanged),
                ],
              ),
            ));
  }

  Widget _buildBarCode(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
              controller: barcodeTextController,
              labelText: AppLocalizations.of(context)!.field_bar_code,
              onChanged: (value) => context.read<SaveGoodCubit>().barCodeChanged(value),
              keyboardType: TextInputType.number),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: CircleButton(Icons.barcode_reader, context.read<SaveGoodCubit>().onBarcodeScannerPressed))
      ],
    );
  }

  Widget _buildQuantity(BuildContext context, SaveGoodState state) {
    return Row(
      children: [
        Expanded(
            child: AppTextField(
          labelText: AppLocalizations.of(context)!.field_quantity,
          keyboardType: TextInputType.number,
          onChanged: (value) => context.read<SaveGoodCubit>().quantityChanged(value),
          controller: quantityTextController,
          inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        )),
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
            labelText: transaction?.type == DocumentType.incoming
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
}
