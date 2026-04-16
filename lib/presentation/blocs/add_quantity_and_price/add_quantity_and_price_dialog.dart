import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/style_size.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../../widget/widget.dart';
import 'add_quantity_and_price_cubit.dart';

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
    double? price = (widget.type == DocumentType.incoming
        ? widget.good.purchasePrice
        : widget.good.salePrice);
    double quantity = 1.0;
    cubit.initState(quantity, price);
    quantityTextController.text =
        StringUtils.getQuantityText(quantity);
    if (price != null) {
      priceTextController.text = Config.simpleCurrencyFormat.format(price);
    } else {
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
        if (state.state is OpenCalculatorToInputQuantityState) {
          showCalculatorPopup(context, state.quantity, (p0) {
            cubit.onQuantityChanged(p0.toString());
            quantityTextController.text = p0.toString();
          });
        } else if (state.state is OpenCalculatorToInputPriceState) {
          showCalculatorPopup(context, state.price, (p0) {
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
                  Text(
                    widget.good.name,
                    style: TextStyle(fontSize: TextSize.extraLarge),
                  ),
                  widget.good.description.isNotEmpty
                      ? Text(widget.good.description)
                      : Container(),
                  widget.good.barCode != null
                      ? Text(widget.good.barCode!)
                      : Container(),
                  Text(
                    sprintf(
                      context.tr("in_stock_text"),
                      [widget.good.quantity],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildQuantity(context, state),
                  SizedBox(height: 16),
                  _buildPrice(context, state),
                  SizedBox(height: 16),
                  _buildAmount(context, state),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(context.tr("cancel")),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(context.tr("ok")),
            onPressed: () async {
              Navigator.of(context).pop(
                {"quantity": state.quantity, "price": state.price},
              );
              //Navigator.of(context).pop({"quantity": 1, "price": state.price});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context, AddQuantityAndPriceState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: quantityTextController,
            labelText: context.tr("quantity"),
            keyboardType: TextInputType.number,
            //inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
            onChanged:
                context.read<AddQuantityAndPriceCubit>().onQuantityChanged,
          ),
        ),
        CircleButton(
          UIConstants.calculatorIconData,
          () => cubit.onQuantityCalculatorPressed(),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, AddQuantityAndPriceState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: widget.type == DocumentType.incoming
                ? context.tr("purchase_price")
                : context.tr("sale_price"),
            controller: priceTextController,
            onChanged: context.read<AddQuantityAndPriceCubit>().onPriceChanged,
          ),
        ),
        CircleButton(
          UIConstants.calculatorIconData,
          () => cubit.onPriceCalculatorPressed(),
        ),
      ],
    );
  }

  Widget _buildAmount(BuildContext context, AddQuantityAndPriceState state) {
    if (state.amount != null) {
      amountTextController.text =
          Config.simpleCurrencyFormat.format(state.amount);
    } else {
      amountTextController.text = "";
    }

    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            readOnly: true,
            labelText: context.tr("amount"),
            controller: amountTextController,
          ),
        ),
      ],
    );
  }
}
