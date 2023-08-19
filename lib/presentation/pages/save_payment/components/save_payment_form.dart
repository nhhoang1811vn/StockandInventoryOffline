import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_payment/bloc/save_payment_cubit.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';

class SavePaymentForm extends StatelessWidget {
  final Payment item;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  SavePaymentForm({Key? key, required this.item}) : super(key: key);

  void showCalculatorPopup(BuildContext context) {
    var calc = SimpleCalculator(
      value: double.parse(amountController.text),
      onChanged: (key, value, expression) {
        amountController.text = Config.simpleCurrencyFormat.format(value);
        context.read<SavePaymentCubit>().amountChanged(amountController.text);
      },
      theme: const CalculatorThemeData(
        displayColor: Colors.white,
        displayStyle: const TextStyle(fontSize: 20, color: Colors.blue),
      ),
    );
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: calc);
        });
  }

  @override
  Widget build(BuildContext context) {
    dateController.text = Config.dateFormat.format(item.date);
    amountController.text = Config.simpleCurrencyFormat.format(item.amount);

    return BlocConsumer<SavePaymentCubit, SavePaymentState>(
        listener: (context, state) {
          if (state.state is SaveItemError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
          } else if (state.state is SaveItemSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop(state.item);
          }
        },
        builder: (context, state) => Stack(
              children: [
                Positioned.fill(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(UIConstants.screenSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: dateController,
                        labelText: AppLocalizations.of(context)!.field_date,
                        keyboardType: TextInputType.datetime,
                        onTapped: () => {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: Config.minTime,
                              maxTime: Config.maxTime, onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            context.read<SavePaymentCubit>().dateChanged(date);
                            dateController.text = Config.dateFormat.format(date);
                          }, currentTime: state.date, locale: LocaleType.vi)
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: AppTextField(
                            controller: amountController,
                            labelText: AppLocalizations.of(context)!.field_amount,
                            onChanged: (value) => context.read<SavePaymentCubit>().amountChanged(value),
                            keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true),
                          )),
                          CircleButton(UIConstants.calculatorIconData, () => showCalculatorPopup(context))
                        ],
                      ),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_desc,
                          initialValue: state.description,
                          onChanged: (value) => context.read<SavePaymentCubit>().descriptionChanged(value),
                          keyboardType: TextInputType.name),

                    ],
                  ),
                ))
              ],
            ));
  }
}
