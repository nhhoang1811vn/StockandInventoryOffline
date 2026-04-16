import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/settings/my_company/bloc/my_company_cubit.dart';

import '../../../widget/app_text_field.dart';
import '../../../widget/primary_button.dart';

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
  Widget build(BuildContext context) {
    return BlocConsumer<MyCompanyCubit, MyCompanyState>(
      listener: (context, state) async {},
      builder: (BuildContext context, MyCompanyState state) {
        companyNameController.text = state.companyName;
        addressController.text = state.address;
        emailController.text = state.email;

        phoneController.text = state.phone;
        taxIDController.text = state.taxID;
        bankDetailsController.text = state.bankDetails;
        return Scaffold(
          appBar: new AppBar(
            title: new Text(
              context.tr("menu_item_my_company"),
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(MyCompanyState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(context.tr("company_info_message")),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AppTextField(
                  controller: companyNameController,
                  labelText:
                      context.tr("field_my_company_name"),
                  hintText: context.tr("field_my_company_name"),
                  keyboardType: TextInputType.name,
                  onChanged: (value) =>
                      context.read<MyCompanyCubit>().companyNameChanged(value),
                ),
                SizedBox(
                  height: 16,
                ),
                AppTextField(
                  controller: addressController,
                  labelText: context.tr("label_address"),
                  hintText: context.tr("hint_address"),
                  keyboardType: TextInputType.name,
                  onChanged: (value) =>
                      context.read<MyCompanyCubit>().addressChanged(value),
                ),
                SizedBox(
                  height: 16,
                ),
                AppTextField(
                  controller: emailController,
                  labelText: context.tr("label_email"),
                  hintText: context.tr("hint_email"),
                  keyboardType: TextInputType.name,
                  onChanged: (value) =>
                      context.read<MyCompanyCubit>().emailChanged(value),
                ),
                SizedBox(
                  height: 16,
                ),
                AppTextField(
                  controller: phoneController,
                  labelText: context.tr("label_phone_number"),
                  hintText: context.tr("hint_phone_number"),
                  keyboardType: TextInputType.name,
                  onChanged: (value) =>
                      context.read<MyCompanyCubit>().phoneNumberChanged(value),
                ),
                SizedBox(
                  height: 16,
                ),
                AppTextField(
                  controller: taxIDController,
                  labelText: context.tr("label_tax_id"),
                  hintText: context.tr("hint_tax_id"),
                  keyboardType: TextInputType.name,
                  onChanged: (value) =>
                      context.read<MyCompanyCubit>().taxIDChanged(value),
                ),
                SizedBox(
                  height: 16,
                ),
                AppTextField(
                  controller: bankDetailsController,
                  labelText: context.tr("label_bank_details"),
                  hintText: context.tr("hint_bank_details"),
                  keyboardType: TextInputType.name,
                  onChanged: (value) =>
                      context.read<MyCompanyCubit>().bankDetailsChanged(value),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: PrimaryButton(context.tr("action_save"), () {
            context.read<MyCompanyCubit>().onSaveButtonClicked();
            Navigator.of(context).pop();
          }),
        ),
      ],
    );
  }
}
