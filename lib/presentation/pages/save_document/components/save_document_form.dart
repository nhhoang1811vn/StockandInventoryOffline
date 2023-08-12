import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';

import '../../../app_style.dart';
import '../../goods/good_item_row.dart';

class SaveDocumentForm extends StatelessWidget {
  final Document item;
  final SaveDocumentState state;

  SaveDocumentForm({Key? key, required this.item, required this.state}) : super(key: key);
  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Widget _buildEmptyTransaction(BuildContext context) {
    dateController.text = Config.dateFormat.format(state.item!.date);
    personNameController.text = state.personName??'';
    searchTextController.text = state.textSearch;
    searchTextController.selection = TextSelection.fromPosition(TextPosition(offset: state.textSearch.length));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(UIConstants.goodIconData, size: 60, color: AppColors.primaryColor),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
                AppLocalizations.of(context)!.empty_goods,
                textAlign: TextAlign.center,
                style: AppStyle.getEmptyTextStyle()))
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

  Widget _buildSearchBar(BuildContext context, SaveDocumentState state) {
    return Visibility(
        child: Card(
          child: ListTile(
            title: TextField(
              //focusNode: searchTextFocusNode,
              controller: searchTextController,
              decoration: InputDecoration(hintText: "Search...", border: InputBorder.none),
              onChanged: context.read<SaveDocumentCubit>().onSearchTextChanged,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  child: IconButton(
                    icon: Icon(UIConstants.cancelIconData),
                    onPressed: () {
                      searchTextController.text = "";
                      context.read<SaveDocumentCubit>().resetSearchText();
                    },
                  ),
                  visible: state.textSearch.isNotEmpty,
                ),
                IconButton(
                  icon: Image.asset(
                    UIConstants.searchBarcodeIconPath,
                    width: 24,
                  ),
                  onPressed: context.read<SaveDocumentCubit>().onSearchBarcodeClicked,
                )
              ],
            ),
          ),
        ),
        visible: state.showSearchBar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                            color: Colors.white,
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
                        color: Colors.white,
                        controller: dateController,
                        labelText: AppLocalizations.of(context)!.field_date,
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTapped: () => {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: Config.minTime,
                              maxTime: Config.maxTime, onChanged: (date) {
                          }, onConfirm: (date) {
                            context.read<SaveDocumentCubit>().dateChanged(date);
                            dateController.text = Config.dateFormat.format(date);
                          }, currentTime: state.date, locale: LocaleType.vi)
                        },
                      )),
                    ],
                  ),
                  AppTextField(
                    color: Colors.white,
                    controller: personNameController,
                    labelText: state.item?.type == DocumentType.incoming
                        ? AppLocalizations.of(context)!.field_supplier
                        : AppLocalizations.of(context)!.field_customer,
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    onTapped: () => {context.read<SaveDocumentCubit>().onPersonClicked()},
                  ),
                  AppTextField(
                      color: Colors.white,
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
        _buildSearchBar(context, state),
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
        )),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 20,
              color: Colors.blue,
              child: IntrinsicHeight(child:  Row(
                children: [
                  SizedBox(width: 16),
                  Text(state.transactions.length.toString(), style: TextStyle(color: Colors.white)),
                  SizedBox(width: 16),
                  VerticalDivider(width: 2, color: Colors.white),
                  SizedBox(width: 16),
                  Text(state.totalQuantity.toString(), style: TextStyle(color: Colors.white)),
                ],
              )),
            ))
      ],
    );
  }
}
