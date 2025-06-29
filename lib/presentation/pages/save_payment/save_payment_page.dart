import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document_paid_status.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/save_payment/components/select_wallet_widget.dart';
import 'package:good_manager/presentation/widgets/category_short_form_widget.dart';
import 'package:good_manager/presentation/widgets/primary_button.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/document.dart';
import '../../../main.dart';
import '../../markdown/md_provider_factory.dart';
import '../../utils.dart';
import '../../widgets/circle_button_widget.dart';
import '../../widgets/snackbar_widgets.dart';
import '../../widgets/wallet_short_form_widget.dart';
import '../app_text_field.dart';
import '../base/base_state.dart';
import '../currency_app_text_field.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/save_payment_cubit.dart';
import 'components/select_category_widget.dart';

class SavePaymentPage extends StatefulWidget {
  final Payment item;

  SavePaymentPage(this.item);

  @override
  State<StatefulWidget> createState() {
    return SavePaymentPageState();
  }
}

class SavePaymentPageState extends State<SavePaymentPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // void _showSelectObjectBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (builderContext) {
  //         return SelectDestObjectWidget(
  //           type: widget.item.type,
  //           onDocumentOptionPressed: () {
  //             Navigator.of(context).pop();
  //             context.read<SavePaymentCubit>().onSelectDocument();
  //           },
  //           onPersonOptionPressed: () {
  //             Navigator.of(context).pop();
  //             context.read<SavePaymentCubit>().onSelectPerson();
  //           },
  //         );
  //       });
  // }

  void _showSelectWalletBottomSheet(BuildContext context) {
    var items = context.read<SavePaymentCubit>().state.wallets;
    var selectedItem = context.read<SavePaymentCubit>().state.selectedWallet;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builderContext) {
          return SelectWalletWidget(
            items: items,
            selectedItem: selectedItem,
            onPressed: (item) {
              Navigator.pop(context);
              context.read<SavePaymentCubit>().onWalletChanged(item);
            },
            onAddButtonPressed: () async {
              int storeId = storage.getSelectedStoreId();
              Wallet item = Wallet();
              item.storeId = storeId;
              item.color = Colors.blue.toARGB32();
              var result = await Navigator.of(context)
                  .pushNamed(Pages.save_wallet, arguments: {"item": item});
              if (result != null) {
                Wallet createdWallet = result as Wallet;
                context.read<SavePaymentCubit>().onWalletChanged(createdWallet);
                context.read<SavePaymentCubit>().onRefreshWallets();
                Navigator.pop(context);
              }
            },
          );
        });
  }

  void _showSelectCategoryBottomSheet(BuildContext context) {
    var categories = context.read<SavePaymentCubit>().state.categories;
    var category = context.read<SavePaymentCubit>().state.selectedCategory;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builderContext) {
          return SelectCategoryWidget(
              categories: categories,
              selectedCategory: category,
              onPressed: (item) {
                Navigator.pop(context);
                context.read<SavePaymentCubit>().onCategoryChanged(item);
              },
              onAddNewButtonPressed: () async {
                PaymentCategory item = PaymentCategory();
                item.type = widget.item.type;
                var result = await Navigator.of(context).pushNamed(
                    Pages.save_payment_category,
                    arguments: {"item": item});
                if (result != null) {
                  PaymentCategory createdCategory = result as PaymentCategory;
                  context
                      .read<SavePaymentCubit>()
                      .onCategoryChanged(createdCategory);
                  context.read<SavePaymentCubit>().onRefreshCategories();
                  Navigator.pop(context);
                }
              });
        });
  }

  Widget _buildPrefixObject(SavePaymentState state) {
    var result = "";
    if (widget.item.type == PaymentType.inbound) {
      if (state.documentId != null) {
        result = AppLocalizations.of(context)!.documents_title +
            " " +
            state.document!.name;
        if (state.customer?.name != null) {
          result += " (${state.customer!.name})";
        }
      } else if (state.customerId != null) {
        result = state.customer!.name;
      } else {
        result = AppLocalizations.of(context)!.hint_select;
      }
    } else {
      if (state.documentId != null) {
        result = AppLocalizations.of(context)!.documents_title +
            " " +
            state.document!.name;
        //result = state.document!.name;
        if (state.supplier?.name != null) {
          result += " (${state.supplier!.name})";
        }
      } else if (state.supplierId != null) {
        result = state.supplier!.name;
      } else {
        result = AppLocalizations.of(context)!.hint_select;
      }
    }
    return Text(result);
  }

  @override
  Widget build(BuildContext context) {
    descriptionController.text = widget.item.description;
    context.read<SavePaymentCubit>().init(widget.item);
    return BlocConsumer<SavePaymentCubit, SavePaymentState>(
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is SaveItemError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarWhenFailure(context));
        } else if (state.state is SaveItemSuccessful) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarWhenSuccess(context));
          Navigator.of(context).pop(state.item);
        } else if (state.state is OpenDocumentListState) {
          var documentType = (widget.item.type == PaymentType.inbound)
              ? DocumentType.outgoing
              : DocumentType.incoming;
          final result = await Navigator.of(context)
              .pushNamed(Pages.document_list, arguments: {
            "documentType": documentType,
            "isSelection": true,
            "setting":
                DocumentsSetting(sortByDateNewestFirst: true, selectedStatus: {
              DocumentPaidStatus.unpaid,
              DocumentPaidStatus.partial,
            })
          });
          if (result != null) {
            Document item = result as Document;
            context.read<SavePaymentCubit>().onDocumentChanged(item);
          }
          context.read<SavePaymentCubit>().resetState();
        } else if (state.state is OpenPersonListState) {
          if (widget.item.type == PaymentType.inbound) {
            final result = await Navigator.of(context).pushNamed(
                Pages.customer_list,
                arguments: {"isSelection": true});
            if (result != null) {
              Customer customer = result as Customer;
              context.read<SavePaymentCubit>().onCustomerChanged(customer);
            }
          } else {
            final result = await Navigator.of(context).pushNamed(
                Pages.supplier_list,
                arguments: {"isSelection": true});
            if (result != null) {
              Supplier supplier = result as Supplier;
              context.read<SavePaymentCubit>().onSupplierChanged(supplier);
            }
          }
        }
      },
      builder: (BuildContext context, SavePaymentState state) {
        if (state.date != null) {
          dateController.text =
              DateFormatFactory.getDateFormat().format(state.date!);
        } else {
          dateController.text = "";
        }
        if (state.amount != null) {
          amountController.text =
              Config.simpleCurrencyFormat.format(state.amount);
        } else {
          amountController.text = "";
        }
        var showSelectDocument = false;
        var showSelectPerson = false;
        if (state.document != null){
          showSelectDocument = true;
        }else{
          showSelectPerson = true;
          if (state.item?.type == PaymentType.outbound){
            //showSelectPerson = true;
            if (state.supplier != null){

            }else{
              showSelectDocument = true;
            }
          }else{
            //showSelectPerson = true;
            if (state.customer != null){

            }else{
              showSelectDocument = true;
            }
          }
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                              labelText: AppLocalizations.of(context)!
                                  .label_select_payment_category,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTapped: () {
                                _showSelectCategoryBottomSheet(context);
                              },
                              prefix: state.selectedCategory == null
                                  ? Text(
                                      AppLocalizations.of(context)!.hint_select)
                                  : CategoryShortFormWidget(
                                      state.selectedCategory!),
                              suffix: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                              )),
                          SizedBox(height: 16),
                          AppTextField(
                              labelText: AppLocalizations.of(context)!
                                  .label_select_wallet,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTapped: () {
                                _showSelectWalletBottomSheet(context);
                              },
                              prefix: state.selectedWallet == null
                                  ? Text(
                                      AppLocalizations.of(context)!.hint_select)
                                  : WalletShortFormWidget(
                                      state.selectedWallet!),
                              suffix: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                              )),
                          SizedBox(height: 16),
                          if (showSelectDocument)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: AppTextField(
                                labelText: AppLocalizations.of(context)!.title_select_document,
                                keyboardType: TextInputType.none,
                                readOnly: true,
                                onTapped: (){
                                  context.read<SavePaymentCubit>().onSelectDocument();
                                },
                                prefix: _buildDocumentPrefix(state),
                                suffix: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                )),
                          ),
                          if (showSelectPerson)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: AppTextField(
                                      labelText: state.item?.type == PaymentType.inbound ? AppLocalizations.of(context)!.customers_select_title : AppLocalizations.of(context)!.suppliers_select_title,
                                      keyboardType: TextInputType.none,
                                      readOnly: true,
                                      onTapped: (){
                                        context.read<SavePaymentCubit>().onSelectPerson();
                                      },
                                      prefix: _buildPersonPrefix(state),
                                      suffix: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 16,
                                      )),
                          ),
                          // SizedBox(height: 100),
                          // AppTextField(
                          //     labelText: widget.item.type == PaymentType.inbound
                          //         ? AppLocalizations.of(context)!
                          //             .label_select_inbound_object
                          //         : AppLocalizations.of(context)!
                          //             .label_select_outbound_object,
                          //     keyboardType: TextInputType.none,
                          //     readOnly: true,
                          //     onTapped: () {
                          //       _showSelectObjectBottomSheet(context);
                          //     },
                          //     prefix: _buildPrefixObject(state),
                          //     suffix: Icon(
                          //       Icons.keyboard_arrow_down,
                          //       size: 16,
                          //     )),
                          // SizedBox(height: 16),
                          AppTextField(
                              labelText: AppLocalizations.of(context)!
                                  .label_description,
                              hintText: AppLocalizations.of(context)!
                                  .hint_description,
                              controller: descriptionController,
                              maxLines: null,
                              minLines: 2,
                              onChanged: (value) => context
                                  .read<SavePaymentCubit>()
                                  .descriptionChanged(value),
                              keyboardType: TextInputType.name),
                          SizedBox(height: 16),
                          AppTextField(
                            controller: dateController,
                            suffix: Icon(Icons.keyboard_arrow_down, size: 16),
                            hintText: AppLocalizations.of(context)!.field_date,
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
                                context
                                    .read<SavePaymentCubit>()
                                    .dateChanged(date);
                                dateController.text =
                                    DateFormatFactory.getDateFormat()
                                        .format(date);
                              },
                                  currentTime: state.date,
                                  locale:
                                      MyApp.getDatePickerLocaleType(context))
                            },
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                  child: CurrencyAppTextField(
                                labelText:
                                    AppLocalizations.of(context)!.field_amount,
                                controller: amountController,
                                onChanged: context
                                    .read<SavePaymentCubit>()
                                    .onAmountChanged,
                              )),
                              CircleButton(UIConstants.calculatorIconData, () {
                                Utils.showCalculatorPopup(context, state.amount,
                                    (p0) {
                                  NumberFormat format = new NumberFormat("0.#");
                                  context
                                      .read<SavePaymentCubit>()
                                      .onAmountChanged(format.format(p0));
                                  amountController.text =
                                      Config.simpleCurrencyFormat.format(p0);
                                });
                              })
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: PrimaryButton(
                      AppLocalizations.of(context)!.action_save, () {
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
          actions: [_buildHelpMenu()],
          title: Text(widget.item.type == PaymentType.inbound
              ? AppLocalizations.of(context)!.save_inbound_payment_title
              : AppLocalizations.of(context)!.save_outbound_payment_title),
        ));
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Pages.help, arguments: {
            "title": AppLocalizations.of(context)!.payments_title,
            "content": MDProviderFactory.get().getHelpText(HelpType.PAYMENTS)
          });
        },
        icon: Icon(Icons.help));
  }
  Widget _buildDocumentPrefix(SavePaymentState state){
    if (state.document != null){
      var text = state.document!.name;
      if (widget.item.type == PaymentType.inbound){
        if (state.customer != null && state.customer!.name.isNotEmpty){
          text += " (${state.customer!.name})";
        }
      }else{
        if (state.supplier != null && state.supplier!.name.isNotEmpty){
          text += " (${state.supplier!.name})";
        }
      }
      return Row(
        children: [
          Icon(UIConstants.documentIconData, size: 20, color: Theme.of(context).colorScheme.primary,),
          SizedBox(width: 8),
          Text(text),
          SizedBox(width: 8),
          GestureDetector(onTap: (){
            context.read<SavePaymentCubit>().onCancelDocument();
          }, child: Icon(Icons.close, size: 20))
        ],
      );
    }else{
      return Text(AppLocalizations.of(context)!.hint_select);
    }
  }
  Widget _buildPersonPrefix(SavePaymentState state){
    if (state.item?.type == PaymentType.inbound && state.customer != null){
      return Row(children: [
        CircleAvatar(child: Text('${state.customer!.name[0] .toUpperCase()}'),),
        SizedBox(width: 8),
        Text(state.customer!.name),
        SizedBox(width: 8),
        GestureDetector(onTap: (){
          context.read<SavePaymentCubit>().onCancelPerson();
        }, child: Icon(Icons.close, size: 20))
      ]);
    }else if (state.item?.type == PaymentType.outbound && state.supplier != null){
      return Row(children: [
        CircleAvatar(child: Text('${state.supplier!.name[0].toUpperCase()}'),),
        SizedBox(width: 8),
        Text(state.supplier!.name),
        SizedBox(width: 8),
        GestureDetector(onTap: (){
          context.read<SavePaymentCubit>().onCancelPerson();
        }, child: Icon(Icons.close, size: 20))
      ]);
    }else{
      return Text(AppLocalizations.of(context)!.hint_select);
    }
  }
}
