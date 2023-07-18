import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';
import 'package:path/path.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../base/base_state.dart';
import '../../goods/good_item_row.dart';
import '../../pages.dart';

class SaveDocumentForm extends StatelessWidget {
  final Document item;

  const SaveDocumentForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController supplierNameController = TextEditingController();
    final TextEditingController customerNameController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    dateController.text = Config.dateFormat.format(item.date);
    //supplierNameController.text = item.supplierName;
    return BlocConsumer<SaveDocumentCubit, SaveDocumentState>(
      listenWhen: (state1, state2) => state1.state != state2.state,
        listener: (context, state) async{
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(snackBarFailureText: state.exceptionError));
          } else if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess());
            Navigator.of(context).pop(state.item);
          } else if (state.state is OpenSupplierListState){
            final result = await Navigator.of(context).pushNamed(Pages.supplier_list, arguments: {"isSelection" : true});
            if (result != null){
              Supplier supplier = result as Supplier;
              supplierNameController.text = supplier.name;
              context.read<SaveDocumentCubit>().onSupplierChanged(supplier);
            }
          } else if (state.state is OpenCustomerListState){

          } else if (state.state is OpenGoodListState){
            final result = await Navigator.of(context).pushNamed(Pages.good_list, arguments: {"isSelection" : true, "documentId": state.id, "documentType": state.item?.type});
            context.read<SaveDocumentCubit>().loadTransactions();
          }
        },
        builder: (context, state) => Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(color: Colors.white,child:  ExpansionTile(
                        title: Text(AppLocalizations.of(context)!.document_information),
                        initiallyExpanded: true,
                        childrenPadding: EdgeInsets.only(left: UIConstants.screenSpace, right: UIConstants.screenSpace),
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                        labelText: AppLocalizations.of(context)!.field_name,
                                        initialValue: state.name.value,
                                        onChanged: (value) => context.read<SaveDocumentCubit>().nameChanged(value),
                                        keyboardType: TextInputType.name,
                                        error: state.name.displayError?.text(context)),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(child: AppTextField(
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
                              Visibility(child: AppTextField(
                                controller: supplierNameController,
                                labelText: AppLocalizations.of(context)!.field_supplier,
                                keyboardType: TextInputType.none,
                                readOnly: true,
                                onTapped: () => {
                                  context.read<SaveDocumentCubit>().onSupplierClicked()
                                },
                              ), visible: state.item?.type == DocumentType.incoming,),
                              //Visibility(child: child),
                              AppTextField(
                                  labelText: AppLocalizations.of(context)!.field_desc,
                                  initialValue: state.description,
                                  onChanged: (value) => context.read<SaveDocumentCubit>().descriptionChanged(value),
                                  keyboardType: TextInputType.name),
                            ],
                          )
                        ],
                      ),),
                      Expanded(child: Stack(children: [
                        Visibility(child: _buildEmptyTransaction(context), visible: state.transactions.isEmpty,),
                        Visibility(child: _buildTransactionsView(context, state), visible: state.transactions.isNotEmpty,)
                      ],))
                    ],
                  ),
                ),
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
            child: Text(AppLocalizations.of(context)!.empty_goods,
                textAlign: TextAlign.center))
      ],
    );
  }
  Widget _buildTransactionsView(BuildContext context, SaveDocumentState state){
    return ListView.separated(
        itemBuilder: (BuildContext context, index) {
          var transaction = state.transactions[index];
          return GoodItemRow(
              transaction.good,
              transaction.quantity,
                  (item) => onPressedTransaction(context, transaction.good, transaction.quantity),
                  (item) => {});
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: state.transactions.length);
  }
  void onPressedTransaction(BuildContext context,Good good, int quantity) async{
    //todo
    /*final result = await Navigator.of(context).pushNamed(Pages.save_good, arguments: {"item": good, "quantity": quantity});
    if (result != null){
      context.read<SaveDocumentCubit>().loadTransactions();
    }*/
  }
  void onLongPressedTransaction(){

  }
}
