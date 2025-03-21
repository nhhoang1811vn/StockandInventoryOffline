import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/currency_app_text_field.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/quick_insert_document_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';

class QuickInsertDocumentWidget extends StatefulWidget {
  final Good good;
  final DocumentType type;

  QuickInsertDocumentWidget(this.good, this.type);

  @override
  State<StatefulWidget> createState() => QuickInsertDocumentWidgetState();
}

class QuickInsertDocumentWidgetState extends State<QuickInsertDocumentWidget> {
  TextEditingController quantityTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController amountTextController = TextEditingController();
  TextEditingController dateTextController = TextEditingController();
  TextEditingController personNameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

  QuickInsertDocumentCubit cubit = QuickInsertDocumentCubit();

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
    return BlocConsumer<QuickInsertDocumentCubit, QuickInsertDocumentState>(
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
          }else if (state.state is OpenPersonListState) {
            if (widget.type == DocumentType.incoming){
              final result = await Navigator.of(context).pushNamed(Pages.supplier_list, arguments: {"isSelection": true});
              if (result != null) {
                Supplier item = result as Supplier;
                context.read<QuickInsertDocumentCubit>().onPersonNameChanged(item.name);
                context.read<QuickInsertDocumentCubit>().onPersonChanged(item.id!);
              }
            }else{
              final result = await Navigator.of(context).pushNamed(Pages.customer_list, arguments: {"isSelection": true});
              if (result != null) {
                Customer item = result as Customer;
                context.read<QuickInsertDocumentCubit>().onPersonNameChanged(item.name);
                context.read<QuickInsertDocumentCubit>().onPersonChanged(item.id!);
              }
            }

          }
        },
        builder: (context, state) => AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.type == DocumentType.incoming)
                      Text(AppLocalizations.of(context)!.incoming_document_text, style: TextStyle(fontSize: 25))
                    else
                      Text(AppLocalizations.of(context)!.outgoing_document_text, style: TextStyle(fontSize: 25)),
                    //Text(widget.good.name, style: TextStyle(fontSize: TextSize.extraLarge)),
                    //widget.good.description.isNotEmpty ? Text(widget.good.description) : Container(),
                    //widget.good.barCode != null ? Text(widget.good.barCode!) : Container(),
                    //Text(sprintf(AppLocalizations.of(context)!.in_stock_text, [widget.good.quantity])),
                    _buildQuantity(context, state),
                    _buildPrice(context, state),
                    _buildAmount(context, state),
                    _buildDate(context, state),
                    _buildPerson(context,state, widget.type),
                    _buildDescription(context, state)
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
                Navigator.of(context).pop(
                    {
                      "quantity": state.quantity,
                      "price": state.price,
                      "date": state.date,
                      "personId": state.personId,
                      "description": state.description
                    });
              },
            ),
          ],
        ));
  }

  Widget _buildQuantity(BuildContext context, QuickInsertDocumentState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: quantityTextController,
            labelText: AppLocalizations.of(context)!.field_quantity,
            keyboardType: TextInputType.number,
            //inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
            onChanged: context.read<QuickInsertDocumentCubit>().onQuantityChanged,
          ),
        ),
        CircleButton(UIConstants.calculatorIconData, () => cubit.onQuantityCalculatorPressed())
      ],
    );
  }

  Widget _buildPrice(BuildContext context, QuickInsertDocumentState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: widget.type == DocumentType.incoming
                ? AppLocalizations.of(context)!.field_purchase_price
                : AppLocalizations.of(context)!.field_sale_price,
            controller: priceTextController,
            onChanged: context.read<QuickInsertDocumentCubit>().onPriceChanged,
          ),
        ),
        CircleButton(UIConstants.calculatorIconData, () => cubit.onPriceCalculatorPressed())
      ],
    );
  }

  Widget _buildAmount(BuildContext context, QuickInsertDocumentState state) {
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
  Widget _buildDate(BuildContext context, QuickInsertDocumentState state){
    if (state.date != null){
      dateTextController.text = DateFormatFactory.getDateFormat().format(state.date!);
    }else{
      dateTextController.text = "";
    }
    return AppTextField(
          controller: dateTextController,
          labelText: AppLocalizations.of(context)!.field_date,
          keyboardType: TextInputType.datetime,
          readOnly: true,
          onTapped: () => {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: Config.minTime,
                maxTime: Config.maxTime,
                onChanged: (date) {}, onConfirm: (date) {
                  context.read<QuickInsertDocumentCubit>().dateChanged(date);
                  dateTextController.text = DateFormatFactory.getDateFormat().format(date);
                }, currentTime: state.date, locale: MyApp.getDatePickerLocaleType(context))
          },
        );
  }

  Widget _buildPerson(BuildContext context, QuickInsertDocumentState state, DocumentType type){
    personNameTextController.text = state.personName ?? '';
    return AppTextField(
      controller: personNameTextController,
      labelText: type == DocumentType.incoming
          ? AppLocalizations.of(context)!.field_supplier
          : AppLocalizations.of(context)!.field_customer,
      keyboardType: TextInputType.none,
      readOnly: true,
      onTapped: () => {context.read<QuickInsertDocumentCubit>().onPersonClicked()},
    );
  }
  Widget _buildDescription(BuildContext context,QuickInsertDocumentState state){
    return AppTextField(
        labelText: AppLocalizations.of(context)!.field_desc,
        initialValue: state.description,
        onChanged: (value) => context.read<QuickInsertDocumentCubit>().descriptionChanged(value),
        keyboardType: TextInputType.name);
  }
}
