import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/save_payment_category/bloc/save_payment_category_cubit.dart';
import 'package:good_manager/presentation/pages/save_payment_category/components/select_symbols_widget.dart';

import '../../constants.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/snackbar_widgets.dart';
import '../base/base_state.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
          } else if (state.state is SaveItemSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop(state.item);
          }
        },
        builder: (BuildContext context, SavePaymentCategoryState state) {
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
          title: Text(AppLocalizations.of(context)!.title_save_category),
        ));
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
                      showModalBottomSheet(context: context,
                      isScrollControlled: true,
                      builder: (builderContext) {
                        return SelectSymbolsWidget(symbol: state.icon!,onPressed: (symbol) {
                          Navigator.of(context).pop();
                          context.read<SavePaymentCategoryCubit>().onIconChanged(symbol);
                        });
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                      child: Center(child: Text(state.icon!, style: TextStyle(fontSize: 36),)),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(AppLocalizations.of(context)!.change_icon, style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.blue),),
                  SizedBox(
                    height: 32,
                  ),
                  AppTextField(
                      labelText: AppLocalizations.of(context)!.label_category_name,
                      hintText: AppLocalizations.of(context)!.hint_name,
                      keyboardType: TextInputType.name,
                      initialValue: state.name.value,
                      onChanged: (value) => context.read<SavePaymentCategoryCubit>().nameChanged(value),
                      error: state.name.displayError?.text(context)
                  ),
                  SizedBox(height: 16),
                  AppTextField(
                    labelText: AppLocalizations.of(context)!.label_description,
                    hintText: AppLocalizations.of(context)!.hint_description,
                    maxLines: null,
                    minLines: 2,
                    keyboardType: TextInputType.name,
                    initialValue: state.description,
                    onChanged: (value) => context.read<SavePaymentCategoryCubit>().descriptionChanged(value),
                  )
                ],
              ),
            )),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Theme
              .of(context)
              .colorScheme
              .surface,
          child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
            context.read<SavePaymentCategoryCubit>().onSaveClicked();
          }),
        )
      ],
    );
  }
}
