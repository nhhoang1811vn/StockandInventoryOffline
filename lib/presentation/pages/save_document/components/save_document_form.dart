import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../base/base_state.dart';
import '../../goods/good_item_row.dart';
import '../../pages.dart';

class SaveDocumentForm extends StatelessWidget {
  final Document item;

  const SaveDocumentForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final TextEditingController supplierNameController = TextEditingController();
    final TextEditingController personNameController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    dateController.text = Config.dateFormat.format(item.date);
    personNameController.text = item.personName ?? '';
    return BlocConsumer<SaveDocumentCubit, SaveDocumentState>(
        listenWhen: (state1, state2) => state1.state != state2.state,
        listener: (context, state) async {
          if (state.state is SaveDocumentFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailureWithText(state.exceptionError));
          } else if (state.state is SaveDocumentSuccessfulState) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop();
            //Navigator.of(context).pop(state.item);
          } else if (state.state is OpenPersonListState) {
            if (state.item?.type == DocumentType.incoming){
              final result = await Navigator.of(context).pushNamed(Pages.supplier_list, arguments: {"isSelection": true});
              if (result != null) {
                Supplier supplier = result as Supplier;
                personNameController.text = supplier.name;
                context.read<SaveDocumentCubit>().onPersonChanged(supplier.id);
              }
            }else{
              //todo
            }

          } else if (state.state is OpenCustomerListState) {
          } else if (state.state is OpenGoodListState) {
            final result = await Navigator.of(context).pushNamed(Pages.good_list,
                arguments: {"isSelection": true, "documentId": state.id, "documentType": state.item?.type});
            context.read<SaveDocumentCubit>().loadTransactions();
          } else if (state.state is OpenSaveGoodState) {
            final finalState = state.state as OpenSaveGoodState;
            final transaction = finalState.item;
            final result = await Navigator.of(context)
                .pushNamed(Pages.save_good, arguments: {"item": transaction.good, "quantity": transaction.quantity});
            if (result != null) {
              Map<String, dynamic> objects = result as Map<String, dynamic>;
              //Good good = objects["item"];
              int quantity = objects["quantity"];
              transaction.quantity = quantity;
              context.read<SaveDocumentCubit>().updateTransaction(transaction);
              context.read<SaveDocumentCubit>().loadTransactions();
            }
          }
        },
        builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.primaryColor,
                  child: ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    title: Text(
                      AppLocalizations.of(context)!.document_information,
                      style: TextStyle(color: Colors.white),
                    ),
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.only(left: UIConstants.screenSpace, right: UIConstants.screenSpace),
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                    color: IntAppColors.whiteColor,
                                    labelText: AppLocalizations.of(context)!.field_name,
                                    initialValue: state.name.value,
                                    onChanged: (value) => context.read<SaveDocumentCubit>().nameChanged(value),
                                    keyboardType: TextInputType.name,
                                    error: state.name.displayError?.text(context)),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                  child: AppTextField(
                                color: IntAppColors.whiteColor,
                                controller: dateController,
                                labelText: AppLocalizations.of(context)!.field_date,
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                onTapped: () => {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: Config.minTime,
                                      maxTime: Config.maxTime, onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    context.read<SaveDocumentCubit>().dateChanged(date);
                                    dateController.text = Config.dateFormat.format(date);
                                  }, currentTime: state.date, locale: LocaleType.vi)
                                },
                              )),
                            ],
                          ),
                          AppTextField(
                            color: IntAppColors.whiteColor,
                            controller: personNameController,
                            labelText: state.item?.type == DocumentType.incoming
                                ? AppLocalizations.of(context)!.field_supplier
                                : AppLocalizations.of(context)!.field_customer,
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            onTapped: () => {context.read<SaveDocumentCubit>().onPersonClicked()},
                          ),
                          AppTextField(
                              color: IntAppColors.whiteColor,
                              labelText: AppLocalizations.of(context)!.field_desc,
                              initialValue: state.description,
                              onChanged: (value) => context.read<SaveDocumentCubit>().descriptionChanged(value),
                              keyboardType: TextInputType.name),
                          SizedBox(height: 16)
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Visibility(
                      child: _buildEmptyTransaction(context),
                      visible: state.transactions.isEmpty,
                    ),
                    Visibility(
                      child: _buildTransactionsView(context, state),
                      visible: state.transactions.isNotEmpty,
                    )
                  ],
                ))
              ],
            ));
  }

  Widget _buildEmptyTransaction(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
            height: 60,
            width: 60,
            child: Image.asset(
              UIConstants.goodIconPath,
            )),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(AppLocalizations.of(context)!.empty_goods, textAlign: TextAlign.center))
      ],
    );
  }

  Widget _buildTransactionsView(BuildContext context, SaveDocumentState state) {
    return ListView.separated(
        itemBuilder: (BuildContext context, index) {
          var transaction = state.transactions[index];
          return GoodItemRow(
              transaction.good,
              transaction.quantity,
              (item) => context.read<SaveDocumentCubit>().onPressedTransaction(transaction),
              (item) => onLongPressedTransaction(context, transaction));
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: state.transactions.length);
  }

  void onPressedTransaction(BuildContext context, DocumentTransaction item) async {}

  void onLongPressedTransaction(BuildContext context, DocumentTransaction item) {
    showDialog(
        context: context,
        builder: (BuildContext a) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteDocumentConfirm(context, item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }

  void showDeleteDocumentConfirm(BuildContext context, DocumentTransaction item) {
    showDialog(
        context: context,
        builder: (BuildContext contextaaa) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(AppLocalizations.of(context)!.message_confirm_delete_no_args),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<SaveDocumentCubit>().deleteTransaction(item);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }
}
