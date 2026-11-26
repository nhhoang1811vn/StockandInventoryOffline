import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/settings/my_company/bloc/my_company_cubit.dart';

import '../../../widget/widget.dart';

class MyCompanyPage extends StatefulWidget {
  MyCompanyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyCompanyPageState();
  }
}

class MyCompanyPageState extends State<MyCompanyPage> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController taxIDController = TextEditingController();
  final TextEditingController bankDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MyCompanyCubit>().init();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    taxIDController.dispose();
    bankDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<MyCompanyCubit, MyCompanyState>(
      listener: (context, state) async {},
      builder: (BuildContext context, MyCompanyState state) {
        companyNameController.text = state.companyName;
        addressController.text = state.address;
        emailController.text = state.email;
        phoneController.text = state.phone;
        taxIDController.text = state.taxID;
        bankDetailsController.text = state.bankDetails;

        return SettingsScaffold(
          title: context.tr("menu_item_my_company"),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    SettingsInfoCard(
                        message: context.tr("company_info_message")),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: companyNameController,
                      labelText: context.tr("field_my_company_name"),
                      hintText: context.tr("field_my_company_name"),
                      keyboardType: TextInputType.name,
                      onChanged: (value) => context
                          .read<MyCompanyCubit>()
                          .companyNameChanged(value),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: addressController,
                      labelText: context.tr("label_address"),
                      hintText: context.tr("hint_address"),
                      keyboardType: TextInputType.name,
                      onChanged: (value) =>
                          context.read<MyCompanyCubit>().addressChanged(value),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: emailController,
                      labelText: context.tr("label_email"),
                      hintText: context.tr("hint_email"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) =>
                          context.read<MyCompanyCubit>().emailChanged(value),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: phoneController,
                      labelText: context.tr("label_phone_number"),
                      hintText: context.tr("hint_phone_number"),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => context
                          .read<MyCompanyCubit>()
                          .phoneNumberChanged(value),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: taxIDController,
                      labelText: context.tr("label_tax_id"),
                      hintText: context.tr("hint_tax_id"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) =>
                          context.read<MyCompanyCubit>().taxIDChanged(value),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: bankDetailsController,
                      labelText: context.tr("label_bank_details"),
                      hintText: context.tr("hint_bank_details"),
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) => context
                          .read<MyCompanyCubit>()
                          .bankDetailsChanged(value),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                      top: BorderSide(
                          color: theme.dividerColor.withValues(alpha: 0.1))),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<MyCompanyCubit>().onSaveButtonClicked();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    context.tr("action_save"),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
