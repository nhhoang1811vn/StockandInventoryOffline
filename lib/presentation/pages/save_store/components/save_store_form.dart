import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/util/entity_image_picker.dart';

import '../../../../domain/entity/entity.dart';
import '../../../../presentation/widget/widget.dart';
import '../../../../util/base64_utils.dart';

class SaveStoreForm extends StatelessWidget {
  final Store item;

  const SaveStoreForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveStoreCubit, SaveStoreState>(
      listener: (context, state) {
        if (state.state is SaveItemError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarWhenFailure(context));
        } else if (state.state is SaveItemSuccessful) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarWhenSuccess(context));
          Navigator.of(context).pop(state.item);
        }
      },
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: EntityPhotoAvatar(
              imageBytes: tryDecodeBase64(state.file),
              fallbackIcon: Icons.store_rounded,
              canEdit: true,
              onTap: () {
                EntityImagePicker.showSourceSheet(
                  context,
                  onImagePicked: (bytes) async {
                    context.read<SaveStoreCubit>().onFileChanged(bytes);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          AppTextField(
            labelText: context.tr("name"),
            hintText: context.tr("hint_name"),
            initialValue: state.name.value,
            onChanged: (value) =>
                context.read<SaveStoreCubit>().nameChanged(value),
            keyboardType: TextInputType.name,
            error: state.name.displayError?.text(context),
          ),
          SizedBox(
            height: 16,
          ),
          AppTextField(
            labelText: context.tr("label_description"),
            hintText: context.tr("hint_description"),
            initialValue: state.description,
            onChanged: (value) =>
                context.read<SaveStoreCubit>().descriptionChanged(value),
            keyboardType: TextInputType.name,
          ),
        ],
      ),
    );
  }
}
