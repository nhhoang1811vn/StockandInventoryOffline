import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/models/email.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';

class SaveCustomerForm extends StatelessWidget {
  final Customer? item;

  const SaveCustomerForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveCustomerCubit, SaveCustomerState>(
        listener: (context, state) {
          if (state.state is SaveItemError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
          } else if (state.state is SaveItemSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop(state.item);
          }
        },
        builder: (context, state) => Stack(
              children: [
                Positioned.fill(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(UIConstants.screenSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_name,
                          initialValue: item?.name,
                          onChanged: (value) => context.read<SaveCustomerCubit>().nameChanged(value),
                          keyboardType: TextInputType.name,
                          error: state.name.displayError?.text(context)),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_desc,
                          initialValue: item?.description,
                          onChanged: (value) => context.read<SaveCustomerCubit>().descriptionChanged(value),
                          keyboardType: TextInputType.name),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_address,
                          initialValue: item?.address,
                          onChanged: (value) => context.read<SaveCustomerCubit>().addressChanged(value),
                          keyboardType: TextInputType.name),
                      AppTextField(
                        labelText: AppLocalizations.of(context)!.field_email,
                        initialValue: item?.email,
                        onChanged: (value) => context.read<SaveCustomerCubit>().emailChanged(value),
                        keyboardType: TextInputType.emailAddress
                      ),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_phone,
                          initialValue: item?.phone,
                          onChanged: (value) => context.read<SaveCustomerCubit>().phoneChanged(value),
                          keyboardType: TextInputType.number),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_tax_ID,
                          initialValue: item?.taxID,
                          onChanged: (value) => context.read<SaveCustomerCubit>().taxIDChanged(value),
                          keyboardType: TextInputType.text),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_bank_details,
                          initialValue: item?.bankDetail,
                          onChanged: (value) => context.read<SaveCustomerCubit>().bankDetailsChanged(value),
                          keyboardType: TextInputType.text),
                    ],
                  ),
                ))
              ],
            ));
  }
}
