import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';

class SaveSupplierForm extends StatelessWidget {
  final Supplier? item;

  const SaveSupplierForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveSupplierCubit, SaveSupplierState>(
        listener: (context, state) {
          if (state.state is SaveItemError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
          } else if (state.state is SaveItemSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop(state.item);
          }
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
                  children: [
                    AppTextField(
                        labelText: AppLocalizations.of(context)!.label_supplier_name,
                        hintText: AppLocalizations.of(context)!.hint_name,
                        initialValue: item?.name,
                        onChanged: (value) => context.read<SaveSupplierCubit>().nameChanged(value),
                        keyboardType: TextInputType.name,
                        error: state.name.displayError?.text(context)),
                    SizedBox(height: 16),
                    AppTextField(
                        labelText: AppLocalizations.of(context)!.label_description,
                        hintText: AppLocalizations.of(context)!.hint_description,
                        maxLines: null,
                        minLines: 2,
                        initialValue: item?.description,
                        onChanged: (value) => context.read<SaveSupplierCubit>().descriptionChanged(value),
                        keyboardType: TextInputType.name),
                    SizedBox(height: 16),
                    AppTextField(
                        labelText: AppLocalizations.of(context)!.label_address,
                        hintText: AppLocalizations.of(context)!.hint_address,
                        initialValue: item?.address,
                        onChanged: (value) => context.read<SaveSupplierCubit>().addressChanged(value),
                        keyboardType: TextInputType.name),
                    SizedBox(height: 16),
                    AppTextField(
                      labelText: AppLocalizations.of(context)!.label_email,
                        hintText: AppLocalizations.of(context)!.hint_email,
                      initialValue: item?.email,
                      onChanged: (value) => context.read<SaveSupplierCubit>().emailChanged(value),
                      keyboardType: TextInputType.emailAddress
                    ),
                    SizedBox(height: 16),
                    AppTextField(
                        labelText: AppLocalizations.of(context)!.label_phone_number,
                        hintText: AppLocalizations.of(context)!.hint_phone_number,
                        initialValue: item?.phone,
                        onChanged: (value) => context.read<SaveSupplierCubit>().phoneChanged(value),
                        keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    AppTextField(
                        labelText: AppLocalizations.of(context)!.label_tax_id,
                        hintText: AppLocalizations.of(context)!.hint_tax_id,
                        initialValue: item?.taxID,
                        onChanged: (value) => context.read<SaveSupplierCubit>().taxIDChanged(value),
                        keyboardType: TextInputType.text),
                    SizedBox(height: 16),
                    AppTextField(
                        labelText: AppLocalizations.of(context)!.label_bank_details,
                        hintText: AppLocalizations.of(context)!.hint_bank_details,
                        initialValue: item?.bankDetail,
                        onChanged: (value) => context.read<SaveSupplierCubit>().bankDetailsChanged(value),
                        keyboardType: TextInputType.text),
                  ],
          ),
        ));
  }
}
