import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_expense/bloc/save_expense_cubit.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../../utils.dart';
import '../../currency_app_text_field.dart';

class SaveExpenseForm extends StatelessWidget {
  final Expense item;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  SaveExpenseForm({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    dateController.text = DateFormatFactory.getDateFormat().format(item.date);
    amountController.text = item.amount == null ? "" : Config.simpleCurrencyFormat.format(item.amount);

    return BlocConsumer<SaveExpenseCubit, SaveExpenseState>(
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
                          labelText: AppLocalizations.of(context)!.field_name,
                          initialValue: state.name.value,
                          onChanged: (value) => context.read<SaveExpenseCubit>().nameChanged(value),
                          keyboardType: TextInputType.name,
                          error: state.name.displayError?.name),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.label_description,
                          hintText: AppLocalizations.of(context)!.hint_description,
                          initialValue: state.description,
                          onChanged: (value) => context.read<SaveExpenseCubit>().descriptionChanged(value),
                          keyboardType: TextInputType.name),
                      AppTextField(
                        controller: dateController,
                        labelText: AppLocalizations.of(context)!.field_date,
                        keyboardType: TextInputType.datetime,
                        onTapped: () => {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: Config.minTime,
                              maxTime: Config.maxTime, onChanged: (date) {
                          }, onConfirm: (date) {
                            context.read<SaveExpenseCubit>().dateChanged(date);
                            dateController.text = DateFormatFactory.getDateFormat().format(date);
                          }, currentTime: state.date, locale: MyApp.getDatePickerLocaleType(context))
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CurrencyAppTextField(
                              labelText: AppLocalizations.of(context)!.field_amount,
                              controller: amountController,
                              onChanged: context.read<SaveExpenseCubit>().onAmountChanged,
                            )),
                          CircleButton(UIConstants.calculatorIconData, () => Utils.showCalculatorPopup(context, state.amount,(p0){
                            NumberFormat format = new NumberFormat("0.#");
                            context.read<SaveExpenseCubit>().onAmountChanged(format.format(p0));
                            amountController.text = Config.simpleCurrencyFormat.format(p0);
                          }))
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ));
  }
}
