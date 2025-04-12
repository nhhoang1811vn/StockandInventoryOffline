import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/wallet.dart';
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
  final TextEditingController documentNameController = TextEditingController();
  void _refreshWalletsAndShowBottomSheetAgain(){
    context.read<SavePaymentCubit>().onRefreshWallets();
    Navigator.pop(context);
    Future.delayed(Duration(milliseconds: 200), () {
      _showSelectWalletBottomSheet(context);
    });
  }
  void _refreshCategoriesAndShowBottomSheetAgain(){
    context.read<SavePaymentCubit>().onRefreshCategories();
    Navigator.pop(context);
    Future.delayed(Duration(milliseconds: 200), () {
      _showSelectCategoryBottomSheet(context);
    });
  }
  void _showCategoryOptionsDialog(PaymentCategory item) {
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () async{
                  Navigator.pop(context);
                  var result = await Navigator.of(context).pushNamed(Pages.save_payment_category, arguments: {"item": item});
                  if (result != null){
                    _refreshCategoriesAndShowBottomSheetAgain();
                  }
                },
                child: Text(AppLocalizations.of(context)!.action_edit),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: (){
                  Navigator.pop(context);
                  context.read<SavePaymentCubit>().deleteCategory(item.id!);
                  _refreshCategoriesAndShowBottomSheetAgain();
                  //showDeleteDocumentConfirm(item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }
  void _showSelectWalletBottomSheet(BuildContext context){
    var items = context.read<SavePaymentCubit>().state.wallets;
    var selectedItem = context.read<SavePaymentCubit>().state.selectedWallet;
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        builder: (builderContext){
          return SelectWalletWidget(
              items: items,
              selectedItem: selectedItem,
              onPressed: (item){
                Navigator.pop(context);
                context.read<SavePaymentCubit>().onWalletChanged(item);
              },
              onAddButtonPressed: () async{
                int storeId = storage.getSelectedStoreId();
                Wallet item = Wallet();
                item.storeId = storeId;
                item.color = Colors.blue.value;
                var result = await Navigator.of(context).pushNamed(Pages.save_wallet, arguments: {"item":  item});
                if (result != null){
                  _refreshWalletsAndShowBottomSheetAgain();
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
              onLongPressed: (item) {
                _showCategoryOptionsDialog(item);
              },
              onAddNewButtonPressed: () async {
                PaymentCategory item = PaymentCategory();
                //item.color = Colors.blue.value;
                item.type = widget.item.type;
                var result =
                    await Navigator.of(context).pushNamed(Pages.save_payment_category, arguments: {"item": item});
                if (result != null) {
                  _refreshCategoriesAndShowBottomSheetAgain();
                }
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    descriptionController.text = widget.item.description;
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
        if (state.date != null) {
          dateController.text = DateFormatFactory.getDateFormat().format(state.date!);
        } else {
          dateController.text = "";
        }
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
                                  readOnly: true,
                                  onTapped: () {
                                    _showSelectCategoryBottomSheet(context);
                                  },
                                  prefix: state.selectedCategory == null
                                      ? Text(AppLocalizations.of(context)!.hint_select)
                                      : CategoryShortFormWidget(state.selectedCategory!),
                                  suffix: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                  )),
                              SizedBox(height: 16),
                              AppTextField(
                                  labelText: AppLocalizations.of(context)!.label_select_wallet,
                                  keyboardType: TextInputType.none,
                                  readOnly: true,
                                  onTapped: () {
                                    _showSelectWalletBottomSheet(context);
                                  },
                                  prefix: state.selectedWallet == null
                                      ? Text(AppLocalizations.of(context)!.hint_select)
                                      : WalletShortFormWidget(state.selectedWallet!),
                                  suffix: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                  )),
                              SizedBox(height: 16),
                              AppTextField(
                                  labelText: AppLocalizations.of(context)!.label_description,
                                  hintText: AppLocalizations.of(context)!.hint_description,
                                  controller: descriptionController,
                                  maxLines: null,
                                  minLines: 2,
                                  onChanged: (value) => context.read<SavePaymentCubit>().descriptionChanged(value),
                                  keyboardType: TextInputType.name),
                              SizedBox(
                                height: 16,
                              ),
                              AppTextField(
                                  controller: documentNameController,
                                  suffix: Icon(Icons.keyboard_arrow_down, size: 16),
                                  labelText: AppLocalizations.of(context)!.label_select_document_no,
                                  hintText: AppLocalizations.of(context)!.hint_select,
                                  keyboardType: TextInputType.none,
                                  readOnly: true,
                                  onTapped: () => {context.read<SavePaymentCubit>().onDocumentNameClicked()}),
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
                  child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
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
          actions: [
            _buildHelpMenu()
          ],
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
}
