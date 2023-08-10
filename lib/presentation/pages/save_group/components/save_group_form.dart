import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../../widgets/circle_button_widget.dart';
import '../../../widgets/images_preview/images_preview_view.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
            Navigator.of(context).pop(state.item);
          } else if (state.state is OpenBarcodeScannerPageState){
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ));
            if (result != "-1"){
              barcodeTextController.text = result;
              context.read<SaveGroupCubit>().barCodeChanged(result);
            }
          }
        },
        builder: (context, state) =>
            Stack(
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
                              onChanged: (value) => context.read<SaveGroupCubit>().nameChanged(value),
                              keyboardType: TextInputType.name,
                              error: state.name.displayError?.text(context)),
                          AppTextField(
                              labelText: AppLocalizations.of(context)!.field_desc,
                              initialValue: state.description,
                              onChanged: (value) => context.read<SaveGroupCubit>().descriptionChanged(value),
                              keyboardType: TextInputType.name),
                          _buildBarCode(context, state),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.field_images,
                              style: TextStyle(color: AppColors.secondaryColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 12),

                          ImagesPreviewView(state.files, false, context
                              .read<SaveGroupCubit>()
                              .onImagesChanged)

                        ],
                      ),
                    ))
              ],
            ));
  }

  Widget _buildBarCode(BuildContext context, SaveGroupState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
              controller: barcodeTextController,
              labelText: AppLocalizations.of(context)!.field_bar_code,
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
