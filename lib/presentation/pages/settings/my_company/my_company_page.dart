import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/settings/my_company/bloc/my_company_cubit.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../widgets/primary_button.dart';
import '../../app_text_field.dart';

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
                title:
                    new Text(AppLocalizations.of(context)!.menu_item_my_company)),
            body: _buildBody(state),
          );
        });
  }

  Widget _buildBody(MyCompanyState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("This data will be displayed in printed form (invoices, sales, receipts, etc..."),
        ),
        Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(children: [
                  AppTextField(
                    controller: companyNameController,
                    labelText: AppLocalizations.of(context)!.field_my_company_name,
                    hintText: AppLocalizations.of(context)!.field_my_company_name,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => context.read<MyCompanyCubit>().companyNameChanged(value),
                  ),
                  SizedBox(height: 16,),
                  AppTextField(
                    controller: addressController,
                    labelText: AppLocalizations.of(context)!.label_address,
                    hintText: AppLocalizations.of(context)!.hint_address,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => context.read<MyCompanyCubit>().addressChanged(value),
                  ),
                  SizedBox(height: 16,),
                  AppTextField(
                    controller: emailController,
                    labelText: AppLocalizations.of(context)!.label_email,
                    hintText: AppLocalizations.of(context)!.hint_email,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => context.read<MyCompanyCubit>().emailChanged(value),
                  ),
                  SizedBox(height: 16,),
                  AppTextField(
                    controller: phoneController,
                    labelText: AppLocalizations.of(context)!.label_phone_number,
                    hintText: AppLocalizations.of(context)!.hint_phone_number,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => context.read<MyCompanyCubit>().phoneNumberChanged(value),
                  ),
                  SizedBox(height: 16,),
                  AppTextField(
                    controller: taxIDController,
                    labelText: AppLocalizations.of(context)!.label_tax_id,
                    hintText: AppLocalizations.of(context)!.hint_tax_id,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => context.read<MyCompanyCubit>().taxIDChanged(value),
                  ),
                  SizedBox(height: 16,),
                  AppTextField(
                    controller: bankDetailsController,
                    labelText: AppLocalizations.of(context)!.label_bank_details,
                    hintText: AppLocalizations.of(context)!.hint_bank_details,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => context.read<MyCompanyCubit>().bankDetailsChanged(value),
                  ),
                ]))),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surface,
          child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
            context.read<MyCompanyCubit>().onSaveButtonClicked();
            Navigator.of(context).pop();
          }),
        )
      ],
    );
  }
}
