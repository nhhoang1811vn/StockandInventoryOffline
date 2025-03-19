import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/save_payment/components/save_payment_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/document.dart';
import '../../utils.dart';
import '../../widgets/circle_button_widget.dart';
import '../../widgets/snackbar_widgets.dart';
import '../app_text_field.dart';
import '../base/base_state.dart';
import '../currency_app_text_field.dart';
import '../pages.dart';
import 'bloc/save_payment_cubit.dart';

class SavePaymentPage extends StatelessWidget {
  final Payment item;

  SavePaymentPage(this.item);

  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController documentNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<SavePaymentCubit>().init(item);
    return BlocConsumer<SavePaymentCubit, SavePaymentState>(
      listener: (context, state) async {
        if (state.state is SaveItemError) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
        } else if (state.state is SaveItemSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
          Navigator.of(context).pop(state.item);
        } else if (state.state is OpenDocumentListState) {
          final result = await Navigator.of(context).pushNamed(Pages.document_list,
              arguments: {"isSelection": true});
          if (result != null) {
            Document item = result as Document;
            context.read<SavePaymentCubit>().onDocumentChanged(item);
          }
        }
      },
      builder: (BuildContext context, SavePaymentState state) {
        documentNameController.text = state.documentName.value;
        dateController.text = Config.dateFormat.format(state.date!);
        if (state.amount != null) {
          amountController.text = Config.simpleCurrencyFormat.format(state.amount);
        } else {
          amountController.text = "";
        }
        return Scaffold(
            appBar: _buildAppBar(context),
            body: Column(
              children: [
                SelectedStoreView(),
                Expanded(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(UIConstants.screenSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_name,
                          initialValue: state.name.value,
                          onChanged: (value) => context.read<SavePaymentCubit>().nameChanged(value),
                          keyboardType: TextInputType.name,
                          error: state.name.displayError?.text(context)),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_desc,
                          initialValue: state.description,
                          onChanged: (value) => context.read<SavePaymentCubit>().descriptionChanged(value),
                          keyboardType: TextInputType.name),
                      AppTextField(
                          controller: documentNameController,
                          labelText: AppLocalizations.of(context)!.field_document_no,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          onTapped: () => {context.read<SavePaymentCubit>().onDocumentNameClicked()},
                          error: state.documentName.displayError?.text(context)),
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
                          }, currentTime: state.date, locale: LocaleType.en)
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CurrencyAppTextField(
                            labelText: AppLocalizations.of(context)!.field_amount,
                            controller: amountController,
                            onChanged: context.read<SavePaymentCubit>().onAmountChanged,
                          )),
                          CircleButton(UIConstants.calculatorIconData, () {
                            Utils.showCalculatorPopup(context, state.amount, (p0) {
                              NumberFormat format = new NumberFormat("0.#");
                              context.read<SavePaymentCubit>().onAmountChanged(format.format(p0));
                              amountController.text = Config.simpleCurrencyFormat.format(p0);
                            });
                          })
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ));
      },
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(title: Text(AppLocalizations.of(context)!.save_payment_title), actions: <Widget>[
          IconButton(
              onPressed: () {
                context.read<SavePaymentCubit>().onSaveClicked();
              },
              icon: Icon(Icons.check))
        ]));
  }
}
