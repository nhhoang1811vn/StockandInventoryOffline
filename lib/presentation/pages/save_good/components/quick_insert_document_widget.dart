import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/quick_insert_document_cubit.dart';
import 'package:good_manager/presentation/widget/widget.dart';

import '../../../../app.dart';
import '../../../../constant/constant.dart';
import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../util/quantity_format.dart';
import '../../../../util/quantity_input.dart';
import '../../../../util/util.dart';
import '../../../dialog/dialog.dart';

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

  DocumentPropertiesSettings get _documentProperties =>
      AppSettings.getDocumentPropertiesSettings();

  /// Price and amount are only asked for when the matching Good property
  /// (Purchase price for incoming, Sale price for outgoing) is enabled.
  bool get _showPrice =>
      AppSettings.getGoodPropertiesSettings().showPriceFor(widget.type);

  @override
  Widget build(BuildContext context) {
    double? price = AppSettings.getGoodPropertiesSettings()
        .defaultPriceFor(widget.good, widget.type);
    double quantity = 1.0;
    cubit.initState(quantity, price);
    quantityTextController.text =
        StringUtils.getQuantityText(quantity); // quantity.toString();
    if (price != null) {
      priceTextController.text = Config.simpleCurrencyFormat.format(price);
    } else {
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
        if (state.state is OpenCalculatorToInputQuantityState) {
          showCalculatorPopup(context, state.quantity, (p0) {
            final text =
                calculatorQuantityText(p0, AppSettings.getQuantityDecimals());
            cubit.onQuantityChanged(text);
            quantityTextController.text = text;
          });
        } else if (state.state is OpenCalculatorToInputPriceState) {
          showCalculatorPopup(context, state.price, (p0) {
            NumberFormat format = new NumberFormat("0.#");
            cubit.onPriceChanged(format.format(p0));
            priceTextController.text = Config.simpleCurrencyFormat.format(p0);
          });
        } else if (state.state is OpenPersonListState) {
          if (widget.type == DocumentType.incoming) {
            final result = await Navigator.of(context).pushNamed(
              Pages.supplier_list,
              arguments: {"isSelection": true},
            );
            if (result != null) {
              Supplier item = result as Supplier;
              context
                  .read<QuickInsertDocumentCubit>()
                  .onPersonNameChanged(item.name);
              context
                  .read<QuickInsertDocumentCubit>()
                  .onPersonChanged(item.id!);
            }
          } else {
            final result = await Navigator.of(context).pushNamed(
              Pages.customer_list,
              arguments: {"isSelection": true},
            );
            if (result != null) {
              Customer item = result as Customer;
              context
                  .read<QuickInsertDocumentCubit>()
                  .onPersonNameChanged(item.name);
              context
                  .read<QuickInsertDocumentCubit>()
                  .onPersonChanged(item.id!);
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
                    Text(
                      context.tr("incoming"),
                      style: TextStyle(fontSize: 25),
                    )
                  else
                    Text(
                      context.tr("outgoing"),
                      style: TextStyle(fontSize: 25),
                    ),
                  SizedBox(height: 16),
                  _buildQuantity(context, state),
                  if (_showPrice) ...[
                    SizedBox(height: 16),
                    _buildPrice(context, state),
                    SizedBox(height: 16),
                    _buildAmount(context, state),
                  ],
                  if (_documentProperties.showDateTime) ...[
                    SizedBox(height: 16),
                    _buildDate(context, state),
                  ],
                  SizedBox(height: 16),
                  _buildPerson(context, state, widget.type),
                  if (_documentProperties.showDescription) ...[
                    SizedBox(height: 16),
                    _buildDescription(context, state),
                  ],
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
              Navigator.of(context).pop({
                "quantity": state.quantity,
                "price": state.price,
                "date": state.date,
                "personId": state.personId,
                "description": state.description,
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context, QuickInsertDocumentState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: quantityTextController,
            labelText: context.tr("quantity"),
            keyboardType: quantityKeyboardType(),
            inputFormatter: quantityInputFormatters(),
            onChanged:
                context.read<QuickInsertDocumentCubit>().onQuantityChanged,
          ),
        ),
        CircleButton(
          UIConstants.calculatorIconData,
          () => cubit.onQuantityCalculatorPressed(),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, QuickInsertDocumentState state) {
    return Row(
      children: [
        Expanded(
          child: CurrencyAppTextField(
            labelText: widget.type == DocumentType.incoming
                ? context.tr("purchase_price")
                : context.tr("sale_price"),
            controller: priceTextController,
            onChanged: context.read<QuickInsertDocumentCubit>().onPriceChanged,
          ),
        ),
        CircleButton(
          UIConstants.calculatorIconData,
          () => cubit.onPriceCalculatorPressed(),
        ),
      ],
    );
  }

  Widget _buildAmount(BuildContext context, QuickInsertDocumentState state) {
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

  Widget _buildDate(BuildContext context, QuickInsertDocumentState state) {
    if (state.date != null) {
      dateTextController.text =
          DateFormatFactory.getDateFormat().format(state.date!);
    } else {
      dateTextController.text = "";
    }
    return AppTextField(
      controller: dateTextController,
      labelText: context.tr("date"),
      keyboardType: TextInputType.datetime,
      suffix: Icon(
        Icons.keyboard_arrow_down,
        size: 16,
      ),
      readOnly: true,
      onTapped: () => {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: Config.minTime,
          maxTime: Config.maxTime,
          onChanged: (date) {},
          onConfirm: (date) {
            context.read<QuickInsertDocumentCubit>().dateChanged(date);
            dateTextController.text =
                DateFormatFactory.getDateFormat().format(date);
          },
          currentTime: state.date,
          locale: MyApp.getDatePickerLocaleType(context),
        ),
      },
    );
  }

  Widget _buildPerson(
    BuildContext context,
    QuickInsertDocumentState state,
    DocumentType type,
  ) {
    personNameTextController.text = state.personName ?? '';
    return AppTextField(
      controller: personNameTextController,
      labelText: type == DocumentType.incoming
          ? context.tr("label_supplier_name")
          : context.tr("label_customer_name"),
      hintText: context.tr("hint_select"),
      keyboardType: TextInputType.none,
      readOnly: true,
      suffix: Icon(
        Icons.keyboard_arrow_down,
        size: 16,
      ),
      onTapped: () =>
          {context.read<QuickInsertDocumentCubit>().onPersonClicked()},
    );
  }

  Widget _buildDescription(
    BuildContext context,
    QuickInsertDocumentState state,
  ) {
    return AppTextField(
      labelText: context.tr("label_description"),
      hintText: context.tr("hint_description"),
      maxLines: null,
      minLines: 2,
      initialValue: state.description,
      onChanged: (value) =>
          context.read<QuickInsertDocumentCubit>().descriptionChanged(value),
      keyboardType: TextInputType.name,
    );
  }
}
