import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';
import 'package:good_manager/domain/entities/models/email.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/supplier.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';

class SaveSupplierForm extends StatelessWidget {
  final Supplier item;

  const SaveSupplierForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveSupplierCubit, SaveSupplierState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(snackBarFailureText: state.exceptionError));
          } else if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess());
            Navigator.of(context).pop();
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
                          initialValue: item.name,
                          onChanged: (value) => context.read<SaveSupplierCubit>().nameChanged(value),
                          keyboardType: TextInputType.name,
                          error: state.name.displayError?.text()),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_desc,
                          initialValue: item.description,
                          onChanged: (value) => context.read<SaveSupplierCubit>().descriptionChanged(value),
                          keyboardType: TextInputType.name),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_address,
                          initialValue: item.address,
                          onChanged: (value) => context.read<SaveSupplierCubit>().addressChanged(value),
                          keyboardType: TextInputType.name),
                      AppTextField(
                        labelText: AppLocalizations.of(context)!.field_email,
                        initialValue: item.email,
                        onChanged: (value) => context.read<SaveSupplierCubit>().emailChanged(value),
                        keyboardType: TextInputType.emailAddress,
                        error: state.email.displayError?.text(),
                      ),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_phone,
                          initialValue: item.phone,
                          onChanged: (value) => context.read<SaveSupplierCubit>().phoneChanged(value),
                          keyboardType: TextInputType.number),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_tax_ID,
                          initialValue: item.taxID,
                          onChanged: (value) => context.read<SaveSupplierCubit>().taxIDChanged(value),
                          keyboardType: TextInputType.text),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_bank_details,
                          initialValue: item.bankDetail,
                          onChanged: (value) => context.read<SaveSupplierCubit>().bankDetailsChanged(value),
                          keyboardType: TextInputType.text),
                    ],
                  ),
                )),
                state.status.isInProgress
                    ? const Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container()
              ],
            ));
  }
}
