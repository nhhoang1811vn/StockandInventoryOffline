import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_customer/save_customer_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_customer_repository.dart';
import 'package:good_manager/domain/entities/customer.dart';

class SaveCustomerPage extends View {
  final Customer item;

  SaveCustomerPage({Key key, @required this.item}) : super(key: key);

  @override
  _SaveCustomerPageView createState() => _SaveCustomerPageView(item);
}

class _SaveCustomerPageView
    extends ViewState<SaveCustomerPage, SaveCustomerController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _SaveCustomerPageView(item)
      : super(SaveCustomerController(DataCustomerRepository(), item));

  @override
  Widget get view => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return WillPopScope(
            key: globalKey,
            child: Scaffold(
                key: globalKey,
                appBar: AppBar(
                    title:
                        Text(AppLocalizations.of(context).save_customer_title),
                    actions: <Widget>[
                      ControlledWidgetBuilder<SaveCustomerController>(
                          builder: (context, controller) {
                        return Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                              onTap: () => controller.checkForm({
                                    'context': context,
                                    'formKey': _formKey,
                                    'globalKey': globalKey
                                  }),
                              child: Icon(Icons.check, size: 26)),
                        );
                      })
                    ]),
                body: ListView(
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: UIConstants.screenSpace,
                              vertical: UIConstants.screenSpace),
                          child: Column(
                            children: <Widget>[
                              name,
                              description,
                              address,
                              email,
                              phone,
                              taxID,
                              bankDetails
                            ],
                          ),
                        ))
                  ],
                )),
            onWillPop: controller.onWillPop);
      });

  Widget get name => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return TextFormField(
            controller: controller.nameTextController,
            onChanged: (a) => controller.validate({
              'context': context,
              'formKey': _formKey,
              'globalKey': globalKey
            }),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).field_name),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return AppLocalizations.of(context).message_name_blank;
              } else {
                return null;
              }
            });
      });

  Widget get description => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });

  Widget get address => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.addressTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_address),
        );
      });

  Widget get email => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.emailTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_email),
        );
      });

  Widget get phone => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.phoneTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_phone),
        );
      });

  Widget get taxID => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.taxIDTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_tax_ID),
        );
      });

  Widget get bankDetails => ControlledWidgetBuilder<SaveCustomerController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.bankDetailsTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_bank_details),
        );
      });
}
