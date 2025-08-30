import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart';

import '../../../../domain/entity/entity.dart';
import '../../../../presentation/widget/widget.dart';
import '../../../review_manager.dart';

class SaveCustomerForm extends StatelessWidget {
  final Customer? item;

  const SaveCustomerForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveCustomerCubit, SaveCustomerState>(
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
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppTextField(
            labelText: AppLocalizations.of(context)!.label_customer_name,
            hintText: AppLocalizations.of(context)!.hint_name,
            initialValue: item?.name,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().nameChanged(value),
            keyboardType: TextInputType.name,
            error: state.name.displayError?.text(context),
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: AppLocalizations.of(context)!.label_description,
            hintText: AppLocalizations.of(context)!.hint_description,
            maxLines: null,
            minLines: 2,
            initialValue: item?.description,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().descriptionChanged(value),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: AppLocalizations.of(context)!.label_address,
            hintText: AppLocalizations.of(context)!.hint_address,
            initialValue: item?.address,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().addressChanged(value),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: AppLocalizations.of(context)!.label_email,
            hintText: AppLocalizations.of(context)!.hint_email,
            initialValue: item?.email,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().emailChanged(value),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: AppLocalizations.of(context)!.label_phone_number,
            hintText: AppLocalizations.of(context)!.hint_phone_number,
            initialValue: item?.phone,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().phoneChanged(value),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: AppLocalizations.of(context)!.label_tax_id,
            hintText: AppLocalizations.of(context)!.hint_tax_id,
            initialValue: item?.taxID,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().taxIDChanged(value),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: AppLocalizations.of(context)!.label_bank_details,
            hintText: AppLocalizations.of(context)!.hint_bank_details,
            initialValue: item?.bankDetail,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().bankDetailsChanged(value),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
