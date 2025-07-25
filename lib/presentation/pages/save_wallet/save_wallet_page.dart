import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/currency_app_text_field.dart';
import 'package:good_manager/presentation/pages/save_wallet/bloc/save_wallet_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../review_manager.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/snackbar_widgets.dart';
import '../base/base_state.dart';

class SaveWalletPage extends StatefulWidget {
  final Wallet item;

  SaveWalletPage(this.item);

  @override
  State<StatefulWidget> createState() {
    return SaveWalletPageState();
  }
}

class SaveWalletPageState extends State<SaveWalletPage> {
  final TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    context.read<SaveWalletCubit>().init(widget.item);
    return BlocConsumer<SaveWalletCubit, SaveWalletState>(
        listenWhen: (state1, state2) => state1.state != state2.state,
        listener: (context, state) async {
          if (state.state is SaveItemError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBarWhenFailure(context));
          } else if (state.state is SaveItemSuccessful) {
            ReviewManager.maybeRequestReview();
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop(state.item);
          }
        },
        builder: (BuildContext context, SaveWalletState state) {
          return Scaffold(
            
            appBar: _buildAppBar(context),
            body: _buildBody(state),
          );
        });
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(
          title: Text(AppLocalizations.of(context)!.save_wallet_title),
        ));
  }

  Widget _buildBody(SaveWalletState state) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (builder) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!
                                .title_pick_color),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: state.color,
                                onColorChanged: (newColor){
                                  context
                                      .read<SaveWalletCubit>()
                                      .onColorChanged(newColor);
                                  Navigator.of(context).pop();
                                }
                              ),
                            ),
                            // actions: [
                            //   TextButton(
                            //     onPressed: () {
                            //       Navigator.of(context)
                            //           .pop(); // Close the dialog
                            //     },
                            //     child: Text(AppLocalizations.of(context)!
                            //         .action_ok),
                            //   ),
                            // ],
                          ));
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: state.color, shape: BoxShape.circle),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                AppLocalizations.of(context)!.change_color,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.blue),
              ),
              SizedBox(
                height: 32,
              ),
              AppTextField(
                labelText: AppLocalizations.of(context)!.label_wallet_name,
                hintText: AppLocalizations.of(context)!.hint_name,
                keyboardType: TextInputType.name,
                initialValue: state.name.value,
                error: state.name.displayError?.text(context),
                onChanged: (value) =>
                    context.read<SaveWalletCubit>().nameChanged(value),
              ),
              SizedBox(height: 16),
              AppTextField(
                labelText: AppLocalizations.of(context)!.label_description,
                hintText: AppLocalizations.of(context)!.hint_description,
                maxLines: null,
                minLines: 2,
                keyboardType: TextInputType.name,
                initialValue: state.description,
                onChanged: (value) => context
                    .read<SaveWalletCubit>()
                    .descriptionChanged(value),
              ),
              if (widget.item.id == null)
                Column(
                  children: [
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: CurrencyAppTextField(
                          labelText:
                              AppLocalizations.of(context)!.field_amount,
                          controller: amountController,
                          onChanged: context
                              .read<SaveWalletCubit>()
                              .onAmountChanged,
                        )),
                        CircleButton(UIConstants.calculatorIconData, () {
                          Utils.showCalculatorPopup(context, state.amount,
                              (p0) {
                            NumberFormat format = new NumberFormat("0.#");
                            context
                                .read<SaveWalletCubit>()
                                .onAmountChanged(format.format(p0));
                            amountController.text =
                                Config.simpleCurrencyFormat.format(p0);
                          });
                        })
                      ],
                    ),
                  ],
                )
            ],
          ),
        )),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
            context.read<SaveWalletCubit>().onSaveClicked();
          }),
        )
      ],
    );
  }
}
