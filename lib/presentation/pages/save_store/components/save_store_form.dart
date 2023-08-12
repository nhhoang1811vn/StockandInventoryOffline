import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';

class SaveStoreForm extends StatelessWidget {
  final Store item;

  const SaveStoreForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveStoreCubit, SaveStoreState>(
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
                          initialValue: state.name.value,
                          onChanged: (value) => context.read<SaveStoreCubit>().nameChanged(value),
                          keyboardType: TextInputType.name,
                          error: state.name.displayError?.text(context)),
                      AppTextField(
                          labelText: AppLocalizations.of(context)!.field_desc,
                          initialValue: state.description,
                          onChanged: (value) => context.read<SaveStoreCubit>().descriptionChanged(value),
                          keyboardType: TextInputType.name),
                    ],
                  ),
                ))
              ],
            ));
  }
}
