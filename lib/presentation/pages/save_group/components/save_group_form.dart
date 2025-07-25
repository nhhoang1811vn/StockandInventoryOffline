import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../../review_manager.dart';
import '../../../utils.dart';
import '../../../widgets/circle_button_widget.dart';

class SaveGroupForm extends StatelessWidget {
  final Group item;
  final barcodeTextController = TextEditingController();

  SaveGroupForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    barcodeTextController.text = item.barCode??'';
    return BlocConsumer<SaveGroupCubit, SaveGroupState>(
        listenWhen: (state1, state2){
          return state1.state != state2.state;
        },
        listener: (context, state) async{
          if (state.state is SaveItemError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(context));
          } else if (state.state is SaveItemSameBarcodeError){
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailureWithText(AppLocalizations.of(context)!.error_same_barcode));
          }
          else if (state.state is SaveItemSuccessful) {
            ReviewManager.maybeRequestReview();
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop(state.item);
          } else if (state.state is OpenBarcodeScannerPageState){
            var result = await Utils.scanBarcode(context);
            if (result != null && result != -1){
              barcodeTextController.text = result;
              context.read<SaveGroupCubit>().barCodeChanged(result);
            }
          }
        },
        builder: (context, state) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppTextField(
                    labelText: AppLocalizations.of(context)!.label_group_name,
                    hintText: AppLocalizations.of(context)!.hint_name,
                    initialValue: state.name.value,
                    onChanged: (value) => context.read<SaveGroupCubit>().nameChanged(value),
                    keyboardType: TextInputType.name,
                    error: state.name.displayError?.text(context)),
                SizedBox(height: 16,),
                AppTextField(
                    labelText: AppLocalizations.of(context)!.label_description,
                    hintText: AppLocalizations.of(context)!.hint_description,
                    initialValue: state.description,
                    maxLines: null,
                    minLines: 2,
                    onChanged: (value) => context.read<SaveGroupCubit>().descriptionChanged(value),
                    keyboardType: TextInputType.name),
                SizedBox(height: 16,),
                _buildBarCode(context, state),
              ],
            ));
  }

  Widget _buildBarCode(BuildContext context, SaveGroupState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
              controller: barcodeTextController,
              labelText: AppLocalizations.of(context)!.label_bar_code,
              hintText: AppLocalizations.of(context)!.hint_bar_code,
              onChanged: (value) => context.read<SaveGroupCubit> ().barCodeChanged(value),
              keyboardType: TextInputType.number),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: CircleButton(Icons.barcode_reader, context.read<SaveGroupCubit>().onBarcodeScannerPressed))

      ],
    );
  }
}
