import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/presentation/pages/save_payment/components/select_wallet_widget.dart';

import '../../../app.dart';
import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/toast_utils.dart';
import '../../dialog/dialog.dart';
import '../../markdown/md_provider_factory.dart';
import '../../review_manager.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
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

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.item.description;
    context.read<SavePaymentCubit>().init(widget.item);
  }

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
            int storeId = context.read<SavePaymentCubit>().getSelectedStoreId();
            Wallet item = Wallet();
            item.storeId = storeId;
            item.color = 0xFF2196F3;
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
      },
    );
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
              arguments: {"item": item},
            );
            if (result != null) {
              PaymentCategory createdCategory = result as PaymentCategory;
              context
                  .read<SavePaymentCubit>()
                  .onCategoryChanged(createdCategory);
              context.read<SavePaymentCubit>().onRefreshCategories();
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavePaymentCubit, SavePaymentState>(
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is SaveItemError) {
          ToastUtils.showErrorToast(context.tr("snackbar_try_again"));
        } else if (state.state is SaveItemSuccessful) {
          ReviewManager.maybeRequestReview();
          ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
          Navigator.of(context).pop(state.item);
        } else if (state.state is OpenDocumentListState) {
          var documentType = (widget.item.type == PaymentType.inbound)
              ? DocumentType.outgoing
              : DocumentType.incoming;
          final result = await Navigator.of(context).pushNamed(
            Pages.document_list,
            arguments: {
              "documentType": documentType,
              "isSelection": true,
              "setting": DocumentsSetting(
                sortByDateNewestFirst: true,
                selectedStatus: {
                  DocumentPaidStatus.unpaid,
                  DocumentPaidStatus.partial,
                },
              ),
            },
          );
          if (result != null) {
            Document item = result as Document;
            context.read<SavePaymentCubit>().onDocumentChanged(item);
          }
          context.read<SavePaymentCubit>().resetState();
        } else if (state.state is OpenPersonListState) {
          if (widget.item.type == PaymentType.inbound) {
            final result = await Navigator.of(context).pushNamed(
              Pages.customer_list,
              arguments: {"isSelection": true},
            );
            if (result != null) {
              Customer customer = result as Customer;
              context.read<SavePaymentCubit>().onCustomerChanged(customer);
            }
          } else {
            final result = await Navigator.of(context).pushNamed(
              Pages.supplier_list,
              arguments: {"isSelection": true},
            );
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
        if (state.document != null) {
          showSelectDocument = true;
        } else {
          showSelectPerson = true;
          if (state.item?.type == PaymentType.outbound) {
            //showSelectPerson = true;
            if (state.supplier != null) {
            } else {
              showSelectDocument = true;
            }
          } else {
            //showSelectPerson = true;
            if (state.customer != null) {
            } else {
              showSelectDocument = true;
            }
          }
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: SaveObjectAppBar(
            title: widget.item.type == PaymentType.inbound
                ? context.tr("save_inbound_payment_title")
                : context.tr("save_outbound_payment_title"),
            actions: [_buildHelpMenu()],
          ),
          body: Column(
            children: [
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
                            labelText:
                                context.tr("label_select_payment_category"),
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            onTapped: () {
                              _showSelectCategoryBottomSheet(context);
                            },
                            prefix: state.selectedCategory == null
                                ? Text(
                                    context.tr("hint_select"),
                                  )
                                : CategoryShortFormWidget(
                                    state.selectedCategory!,
                                  ),
                            suffix: Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          AppTextField(
                            labelText: context.tr("label_select_wallet"),
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            onTapped: () {
                              _showSelectWalletBottomSheet(context);
                            },
                            prefix: state.selectedWallet == null
                                ? Text(
                                    context.tr("hint_select"),
                                  )
                                : WalletShortFormWidget(
                                    state.selectedWallet!,
                                  ),
                            suffix: Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (showSelectDocument)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: AppTextField(
                                labelText: context.tr("title_select_document"),
                                keyboardType: TextInputType.none,
                                readOnly: true,
                                onTapped: () {
                                  context
                                      .read<SavePaymentCubit>()
                                      .onSelectDocument();
                                },
                                prefix: _buildDocumentPrefix(state),
                                suffix: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                ),
                              ),
                            ),
                          if (showSelectPerson)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: AppTextField(
                                labelText:
                                    state.item?.type == PaymentType.inbound
                                        ? context.tr("select_customer")
                                        : context.tr("select_supplier"),
                                keyboardType: TextInputType.none,
                                readOnly: true,
                                onTapped: () {
                                  context
                                      .read<SavePaymentCubit>()
                                      .onSelectPerson();
                                },
                                prefix: _buildPersonPrefix(state),
                                suffix: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                ),
                              ),
                            ),
                          // SizedBox(height: 100),
                          // AppTextField(
                          //     labelText: widget.item.type == PaymentType.inbound
                          //         ? context.tr("
                          //             .label_select_inbound_object
                          //         : context.tr("
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
                            labelText: context.tr("label_description"),
                            hintText: context.tr("hint_description"),
                            controller: descriptionController,
                            maxLines: null,
                            minLines: 2,
                            onChanged: (value) => context
                                .read<SavePaymentCubit>()
                                .descriptionChanged(value),
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 16),
                          AppTextField(
                            controller: dateController,
                            suffix: Icon(Icons.keyboard_arrow_down, size: 16),
                            hintText: context.tr("date"),
                            labelText: context.tr("date"),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            onTapped: () => {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: Config.minTime,
                                maxTime: Config.maxTime,
                                onChanged: (date) {
                                  print('change $date');
                                },
                                onConfirm: (date) {
                                  context
                                      .read<SavePaymentCubit>()
                                      .dateChanged(date);
                                  dateController.text =
                                      DateFormatFactory.getDateFormat()
                                          .format(date);
                                },
                                currentTime: state.date,
                                locale: MyApp.getDatePickerLocaleType(context),
                              ),
                            },
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CurrencyAppTextField(
                                  labelText: context.tr("amount"),
                                  controller: amountController,
                                  onChanged: context
                                      .read<SavePaymentCubit>()
                                      .onAmountChanged,
                                ),
                              ),
                              CircleButton(UIConstants.calculatorIconData, () {
                                showCalculatorPopup(context, state.amount,
                                    (p0) {
                                  NumberFormat format = new NumberFormat("0.#");
                                  context
                                      .read<SavePaymentCubit>()
                                      .onAmountChanged(format.format(p0));
                                  amountController.text =
                                      Config.simpleCurrencyFormat.format(p0);
                                });
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: PrimaryButton(context.tr("action_save"), () {
                  context.read<SavePaymentCubit>().onSaveClicked();
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpMenu() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          Pages.help,
          arguments: {
            "title": context.tr("payments_title"),
            "content": MDProviderFactory.get().getHelpText(HelpType.PAYMENTS),
          },
        );
      },
      icon: Icon(Icons.help),
    );
  }

  Widget _buildDocumentPrefix(SavePaymentState state) {
    if (state.document != null) {
      var text = state.document!.name;
      if (widget.item.type == PaymentType.inbound) {
        if (state.customer != null && state.customer!.name.isNotEmpty) {
          text += " (${state.customer!.name})";
        }
      } else {
        if (state.supplier != null && state.supplier!.name.isNotEmpty) {
          text += " (${state.supplier!.name})";
        }
      }
      return Row(
        children: [
          Icon(
            UIConstants.documentIconData,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 8),
          Text(text),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              context.read<SavePaymentCubit>().onCancelDocument();
            },
            child: Icon(Icons.close, size: 20),
          ),
        ],
      );
    } else {
      return Text(context.tr("hint_select"));
    }
  }

  Widget _buildPersonPrefix(SavePaymentState state) {
    if (state.item?.type == PaymentType.inbound && state.customer != null) {
      return Row(
        children: [
          CircleAvatar(
            child: Text('${state.customer!.name[0].toUpperCase()}'),
          ),
          SizedBox(width: 8),
          Text(state.customer!.name),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              context.read<SavePaymentCubit>().onCancelPerson();
            },
            child: Icon(Icons.close, size: 20),
          ),
        ],
      );
    } else if (state.item?.type == PaymentType.outbound &&
        state.supplier != null) {
      return Row(
        children: [
          CircleAvatar(
            child: Text('${state.supplier!.name[0].toUpperCase()}'),
          ),
          SizedBox(width: 8),
          Text(state.supplier!.name),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              context.read<SavePaymentCubit>().onCancelPerson();
            },
            child: Icon(Icons.close, size: 20),
          ),
        ],
      );
    } else {
      return Text(context.tr("hint_select"));
    }
  }
}
