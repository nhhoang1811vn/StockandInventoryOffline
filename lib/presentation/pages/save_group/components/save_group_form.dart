import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/models/name.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';

import '../../../../presentation/widgets/snackbar_widgets.dart';
import '../../../widgets/images_preview/images_preview_view.dart';

class SaveGroupForm extends StatelessWidget {
  final Group item;

  const SaveGroupForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveGroupCubit, SaveGroupState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailure(snackBarFailureText: state.exceptionError));
          } else if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess());
            Navigator.of(context).pop(state.item);
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
                              style: TextStyle(color: UIConstants.primaryColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 12),
                          ImagesPreviewView(state.files, false, context
                              .read<SaveGroupCubit>()
                              .onImagesChanged)

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

  Widget _buildBarCode(BuildContext context, SaveGroupState state) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
              labelText: AppLocalizations.of(context)!.field_bar_code,
              initialValue: state.barCode,
              onChanged: (value) => context.read<SaveGroupCubit> ().barCodeChanged(value),
              keyboardType: TextInputType.number),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              minWidth: 24,
              //onPressed: controller.onInputBarCodePressed,
              color: Colors.blue,
              textColor: Colors.white,
              child: Icon(
                Icons.barcode_reader,
                size: 24,
              ),
              padding: EdgeInsets.all(8),
              shape: CircleBorder(),
              onPressed: () {},
            ))
      ],
    );
  }
}
