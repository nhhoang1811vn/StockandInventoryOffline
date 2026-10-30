import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/save_payment_category/bloc/save_payment_category_cubit.dart';
import 'package:good_manager/presentation/pages/save_payment_category/components/select_symbols_widget.dart';

import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
import '../../../util/toast_utils.dart';

class SavePaymentCategoryPage extends StatefulWidget {
  final PaymentCategory item;

  SavePaymentCategoryPage(this.item);

  @override
  State<StatefulWidget> createState() {
    return SavePaymentCategoryPageState();
  }
}

class SavePaymentCategoryPageState extends State<SavePaymentCategoryPage> {
  @override
  Widget build(BuildContext context) {
    context.read<SavePaymentCategoryCubit>().init(widget.item);
    return BlocConsumer<SavePaymentCategoryCubit, SavePaymentCategoryState>(
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is SaveItemError) {
          ToastUtils.showErrorToast(context.tr("snackbar_try_again"));
        } else if (state.state is SaveItemSuccessful) {
          ToastUtils.showSuccessToast(context.tr("snackbar_saved"));
          Navigator.of(context).pop(state.item);
        }
      },
      builder: (BuildContext context, SavePaymentCategoryState state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: SaveObjectAppBar(title: context.tr("title_save_category")),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(SavePaymentCategoryState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (builderContext) {
                        return SelectSymbolsWidget(
                          symbol: state.icon!,
                          onPressed: (symbol) {
                            Navigator.of(context).pop();
                            context
                                .read<SavePaymentCategoryCubit>()
                                .onIconChanged(symbol);
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        state.icon!,
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  context.tr("change_icon"),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.blue),
                ),
                SizedBox(
                  height: 32,
                ),
                AppTextField(
                  labelText: context.tr("label_category_name"),
                  hintText: context.tr("hint_name"),
                  keyboardType: TextInputType.name,
                  initialValue: state.name.value,
                  onChanged: (value) => context
                      .read<SavePaymentCategoryCubit>()
                      .nameChanged(value),
                  error: state.name.displayError?.text(context),
                ),
                SizedBox(height: 16),
                AppTextField(
                  labelText: context.tr("label_description"),
                  hintText: context.tr("hint_description"),
                  maxLines: null,
                  minLines: 2,
                  keyboardType: TextInputType.name,
                  initialValue: state.description,
                  onChanged: (value) => context
                      .read<SavePaymentCategoryCubit>()
                      .descriptionChanged(value),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: PrimaryButton(context.tr("action_save"), () {
            context.read<SavePaymentCategoryCubit>().onSaveClicked();
          }),
        ),
      ],
    );
  }
}
