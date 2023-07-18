
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:formz/formz.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/save_expense/bloc/save_expense_cubit.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';

class SaveExpenseForm extends StatelessWidget {
  final Expense item;

  const SaveExpenseForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    dateController.text = Config.dateFormat.format(item.date);
    amountController.text = item.amount.toString();

    return BlocConsumer<SaveExpenseCubit, SaveExpenseState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(snackBarFailureText: state.exceptionError));
          } else if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess());
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
                          error: state.name.displayError?.text(context)),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_desc,
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
                            print('change $date');
                          }, onConfirm: (date) {
                            context.read<SaveExpenseCubit>().dateChanged(date);
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
                            //initialValue: state.amount.toString(),
                            onChanged: (value) => context.read<SaveExpenseCubit>().amountChanged(double.parse(value)),
                            keyboardType: TextInputType.number,
                          )),
                          IconButton(
                              icon: Image.asset(
                                UIConstants.calculatorIconPath,
                                width: 24,
                              ),
                              onPressed: () {
                                var calc = SimpleCalculator(
                                  onChanged: (key, value, expression) {
                                    if (key == '=') {
                                      amountController.text = value.toString();
                                      context.read<SaveExpenseCubit>().amountChanged(value ?? 0);
                                    }
                                  },
                                  theme: const CalculatorThemeData(
                                    displayColor: Colors.black,
                                    displayStyle: const TextStyle(fontSize: 20, color: Colors.yellow),
                                  ),
                                );
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: calc);
                                    });
                              })
                        ],
                      )
                    ],
                  ),
                )),
                state.status.isInProgress
                    ? const Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container()
              ],
            ));
  }
}
