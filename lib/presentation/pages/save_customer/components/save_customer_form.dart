import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart';
import 'package:good_manager/util/entity_image_picker.dart';

import '../../../../constant/constant.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../presentation/widget/widget.dart';
import '../../../../util/base64_utils.dart';
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
          Center(
            child: EntityPhotoAvatar(
              imageBytes: tryDecodeBase64(state.file),
              fallbackIcon: UIConstants.customerIconData,
              canEdit: true,
              onTap: () {
                EntityImagePicker.showSourceSheet(
                  context,
                  onImagePicked: (bytes) async {
                    context.read<SaveCustomerCubit>().onFileChanged(bytes);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          AppTextField(
            labelText: context.tr("label_customer_name"),
            hintText: context.tr("hint_name"),
            initialValue: item?.name,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().nameChanged(value),
            keyboardType: TextInputType.name,
            error: state.name.displayError?.text(context),
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: context.tr("label_description"),
            hintText: context.tr("hint_description"),
            maxLines: null,
            minLines: 2,
            initialValue: item?.description,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().descriptionChanged(value),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: context.tr("label_address"),
            hintText: context.tr("hint_address"),
            initialValue: item?.address,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().addressChanged(value),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: context.tr("label_email"),
            hintText: context.tr("hint_email"),
            initialValue: item?.email,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().emailChanged(value),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: context.tr("label_phone_number"),
            hintText: context.tr("hint_phone_number"),
            initialValue: item?.phone,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().phoneChanged(value),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: context.tr("label_tax_id"),
            hintText: context.tr("hint_tax_id"),
            initialValue: item?.taxID,
            onChanged: (value) =>
                context.read<SaveCustomerCubit>().taxIDChanged(value),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16),
          AppTextField(
            labelText: context.tr("label_bank_details"),
            hintText: context.tr("hint_bank_details"),
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
