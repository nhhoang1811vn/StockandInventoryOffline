import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/style_size.dart';
import 'package:good_manager/presentation/widgets/add_quantity_and_price/add_quantity_and_price_cubit.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import '../../../domain/entities/document.dart';
import '../../pages/app_text_field.dart';
import '../../pages/currency_app_text_field.dart';
import '../../utils.dart';

class AddQuantityAndPriceWidget extends StatefulWidget {
  final Good good;
  final DocumentType type;

  AddQuantityAndPriceWidget(this.good, this.type);

  @override
  State<StatefulWidget> createState() => AddQuantityAndPriceWidgetState();
}

class AddQuantityAndPriceWidgetState extends State<AddQuantityAndPriceWidget> {
  TextEditingController quantityTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController amountTextController = TextEditingController();

  AddQuantityAndPriceCubit cubit = AddQuantityAndPriceCubit();

  @override
  Widget build(BuildContext context) {
    double? price = (widget.type == DocumentType.incoming ? widget.good.purchasePrice : widget.good.salePrice);
    double quantity = 1.0;
    cubit.initState(quantity, price);
    quantityTextController.text = Utils.getQuantityText(quantity);// quantity.toString();
    if (price != null){
      priceTextController.text = Config.simpleCurrencyFormat.format(price);
    }else{
      priceTextController.text = "";
    }
    return BlocProvider(create: (_) => cubit, child: _buildBody(context));
  }
  Widget _buildBody(BuildContext context) {
    return BlocConsumer<AddQuantityAndPriceCubit, AddQuantityAndPriceState>(
        listenWhen: (state1, state2) {
          return state1.state != state2.state;
        },
        listener: (context, state) async {
          if (state.state is OpenCalculatorToInputQuantityState){
            Utils.showCalculatorPopup(context, state.quantity, (p0){
              cubit.onQuantityChanged(p0.toString());
              quantityTextController.text = p0.toString();
            });
          }else if (state.state is OpenCalculatorToInputPriceState){
            Utils.showCalculatorPopup(context, state.price,(p0){
              NumberFormat format = new NumberFormat("0.#");
              cubit.onPriceChanged(format.format(p0));
              priceTextController.text = Config.simpleCurrencyFormat.format(p0);
            });
          }
        },
        builder: (context, state) => AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.good.name, style: TextStyle(fontSize: TextSize.extraLarge)),
                        widget.good.description.isNotEmpty ? Text(widget.good.description) : Container(),
                        widget.good.barCode != null ? Text(widget.good.barCode!) : Container(),
                        Text(sprintf(AppLocalizations.of(context)!.in_stock_text, [widget.good.quantity])),
                        SizedBox(height: 16),
                        _buildQuantity(context, state),
                        SizedBox(height: 16),
                        _buildPrice(context, state),
                        SizedBox(height: 16),
                        _buildAmount(context, state)
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.action_cancel),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.action_ok),
                  onPressed: () async {
                    Navigator.of(context).pop({"quantity": state.quantity, "price": state.price});
                    //Navigator.of(context).pop({"quantity": 1, "price": state.price});
                  },
                ),
              ],
            ));
  }

  Widget _buildQuantity(BuildContext context, AddQuantityAndPriceState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: quantityTextController,
            labelText: AppLocalizations.of(context)!.field_quantity,
            keyboardType: TextInputType.number,
            //inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
            onChanged: context.read<AddQuantityAndPriceCubit>().onQuantityChanged,
          ),
        ),
        CircleButton(UIConstants.calculatorIconData, () => cubit.onQuantityCalculatorPressed())
      ],
    );
  }

  Widget _buildPrice(BuildContext context, AddQuantityAndPriceState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: widget.type == DocumentType.incoming
              ? AppLocalizations.of(context)!.field_purchase_price
              : AppLocalizations.of(context)!.field_sale_price,
            controller: priceTextController,
            onChanged: context.read<AddQuantityAndPriceCubit>().onPriceChanged,
          ),
        ),
        CircleButton(UIConstants.calculatorIconData, () => cubit.onPriceCalculatorPressed())
      ],
    );
  }

  Widget _buildAmount(BuildContext context, AddQuantityAndPriceState state) {
    if (state.amount != null){
      amountTextController.text = Config.simpleCurrencyFormat.format(state.amount);
    }else{
      amountTextController.text = "";
    }

    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            readOnly: true,
            labelText: AppLocalizations.of(context)!.field_amount,
            controller: amountTextController,
          ),
        ),
      ],
    );
  }
}
