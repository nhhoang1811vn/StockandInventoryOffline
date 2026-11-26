import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/save_wallet/bloc/save_wallet_cubit.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/toast_utils.dart';
import '../../dialog/dialog.dart';
import '../../review_manager.dart';
import '../../widget/widget.dart';
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
  void initState() {
    context.read<SaveWalletCubit>().init(widget.item);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveWalletCubit, SaveWalletState>(
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is SaveItemError) {
          ToastUtils.showErrorToast(context.tr("snackbar_try_again"));
        } else if (state.state is SaveItemSuccessful) {
          ReviewManager.maybeRequestReview();
          ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
          Navigator.of(context).pop(state.item);
        }
      },
      builder: (BuildContext context, SaveWalletState state) {
        return UnsavedChangesGuard(
            child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: SaveObjectAppBar(title: context.tr("save_wallet_title")),
          body: _buildBody(state),
        ));
      },
    );
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
                    showSelectColorDialog(
                      context,
                      color: state.color,
                      onItemSelected: (item) {
                        hideDialog(context);
                        context.read<SaveWalletCubit>().onColorChanged(item);
                      },
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: state.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(context.tr("change_color"),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
                SizedBox(
                  height: 32,
                ),
                AppTextField(
                  labelText: context.tr("label_wallet_name"),
                  hintText: context.tr("hint_name"),
                  keyboardType: TextInputType.name,
                  initialValue: state.name.value,
                  error: state.name.displayError?.text(context),
                  onChanged: (value) =>
                      context.read<SaveWalletCubit>().nameChanged(value),
                ),
                SizedBox(height: 16),
                AppTextField(
                  labelText: context.tr("label_description"),
                  hintText: context.tr("hint_description"),
                  maxLines: null,
                  minLines: 2,
                  keyboardType: TextInputType.name,
                  initialValue: state.description,
                  onChanged: (value) =>
                      context.read<SaveWalletCubit>().descriptionChanged(value),
                ),
                if (widget.item.id == null)
                  Column(
                    children: [
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CurrencyAppTextField(
                              labelText: context.tr("amount"),
                              controller: amountController,
                              onChanged: context
                                  .read<SaveWalletCubit>()
                                  .onAmountChanged,
                            ),
                          ),
                          CircleButton(UIConstants.calculatorIconData, () {
                            showCalculatorPopup(context, state.amount, (p0) {
                              NumberFormat format = new NumberFormat("0.#");
                              context
                                  .read<SaveWalletCubit>()
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
            context.read<SaveWalletCubit>().onSaveClicked();
          }),
        ),
      ],
    );
  }
}
