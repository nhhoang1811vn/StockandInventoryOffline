import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/save_payment/components/select_payment_category.dart';
import 'package:good_manager/presentation/widgets/primary_button.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/document.dart';
import '../../../main.dart';
import '../../utils.dart';
import '../../widgets/circle_button_widget.dart';
import '../../widgets/snackbar_widgets.dart';
import '../app_text_field.dart';
import '../base/base_state.dart';
import '../currency_app_text_field.dart';
import '../pages.dart';
import 'bloc/save_payment_cubit.dart';
import 'components/row_payment_category.dart';

class SavePaymentPage extends StatefulWidget {
  final Payment item;

  SavePaymentPage(this.item);

  @override
  State<StatefulWidget> createState() {
    return SavePaymentPageState();
  }
}

class SavePaymentPageState extends State<SavePaymentPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController documentNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<SavePaymentCubit>().init(widget.item);
    return BlocConsumer<SavePaymentCubit, SavePaymentState>(
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is SaveItemError) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
        } else if (state.state is SaveItemSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
          Navigator.of(context).pop(state.item);
        } else if (state.state is OpenDocumentListState) {
          var documentType = (widget.item.type == PaymentType.inbound) ? DocumentType.outgoing : DocumentType.incoming;
          final result =
              await Navigator.of(context).pushNamed(Pages.select_document, arguments: {"documentType": documentType});
          if (result != null) {
            Document item = result as Document;
            context.read<SavePaymentCubit>().onDocumentChanged(item);
          }
          context.read<SavePaymentCubit>().resetState();
        }
      },
      builder: (BuildContext context, SavePaymentState state) {
        documentNameController.text = state.documentName.value;
        dateController.text = DateFormatFactory.getDateFormat().format(state.date!);
        if (state.amount != null) {
          amountController.text = Config.simpleCurrencyFormat.format(state.amount);
        } else {
          amountController.text = "";
        }
        return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: _buildAppBar(context),
            body: Column(
              children: [
                SelectedStoreView(),
                Expanded(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(UIConstants.screenSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                  labelText: AppLocalizations.of(context)!.label_select_payment_category,
                                  keyboardType: TextInputType.none,
                                  onTapped: (){
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (builderContext) {
                                                return SelectPaymentCategoryWidget(state.categories, (index) {
                                                  context.read<SavePaymentCubit>().onCategoryChanged(index);
                                                });
                                              });
                                  },
                                  prefix: Row(children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          color: Color(state.categories[state.selectedCategoryIndex].color),
                                          shape: BoxShape.circle),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(child: Text(state.categories[state.selectedCategoryIndex].name)),
                                  ]),
                                  suffix: Icon(Icons.keyboard_arrow_down)),
                              SizedBox(height: 16),
                              AppTextField(
                                  labelText: AppLocalizations.of(context)!.label_description,
                                  hintText: AppLocalizations.of(context)!.hint_description,
                                  initialValue: state.description,
                                  onChanged: (value) => context.read<SavePaymentCubit>().descriptionChanged(value),
                                  keyboardType: TextInputType.name),
                              SizedBox(
                                height: 16,
                              ),
                              AppTextField(
                                  controller: documentNameController,
                                  suffix: Icon(Icons.keyboard_arrow_down),
                                  labelText: AppLocalizations.of(context)!.label_select_document_no,
                                  hintText: AppLocalizations.of(context)!.hint_select_document_no,
                                  keyboardType: TextInputType.none,
                                  readOnly: true,
                                  onTapped: () => {context.read<SavePaymentCubit>().onDocumentNameClicked()}),
                              SizedBox(height: 16),
                              AppTextField(
                                controller: dateController,
                                hintText: AppLocalizations.of(context)!.field_date,
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
                                    dateController.text = DateFormatFactory.getDateFormat().format(date);
                                  }, currentTime: state.date, locale: MyApp.getDatePickerLocaleType(context))
                                },
                              ),
                              SizedBox(height: 16),
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
                        ),
                      ),
                    ],
                  ),
                )),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.surface,
                  child: PrimaryButton("Save", () {
                    context.read<SavePaymentCubit>().onSaveClicked();
                  }),
                )
              ],
            ));
      },
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(
          title: Text(widget.item.type == PaymentType.inbound
              ? AppLocalizations.of(context)!.save_inbound_payment_title
              : AppLocalizations.of(context)!.save_outbound_payment_title),
        ));
  }
}
