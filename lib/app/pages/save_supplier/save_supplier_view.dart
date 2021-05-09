import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_controller.dart';
import 'package:good_manager/data/repositories/data_supplier_repository.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

class SaveSupplierPage extends View {
  final bool isInsert;
  final Supplier item;

  SaveSupplierPage({Key key, @required this.isInsert, this.item})
      : super(key: key);

  @override
  _SaveSupplierPageView createState() => _SaveSupplierPageView(isInsert, item);
}

class _SaveSupplierPageView
    extends ViewState<SaveSupplierPage, SaveSupplierController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _SaveSupplierPageView(isInsert, item)
      : super(SaveSupplierController(DataSupplierRepository(), isInsert, item));

  @override
  Widget get view => Scaffold(
      key: globalKey,
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).save_supplier_title),
          actions: <Widget>[
            ControlledWidgetBuilder<SaveSupplierController>(
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
                    horizontal: 20.0, vertical: 20.0),
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
      ));

  Widget get name => ControlledWidgetBuilder<SaveSupplierController>(
          builder: (context, controller) {
        return TextFormField(
            controller: controller.nameTextController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).field_name),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "error";
              } else {
                return null;
              }
            });
      });

  Widget get description => ControlledWidgetBuilder<SaveSupplierController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });

  Widget get address => ControlledWidgetBuilder<SaveSupplierController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.addressTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_address),
        );
      });

  Widget get email => ControlledWidgetBuilder<SaveSupplierController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.emailTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_email),
        );
      });
  Widget get phone => ControlledWidgetBuilder<SaveSupplierController>(
      builder: (context, controller) {
        return TextFormField(
          controller: controller.phoneTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_phone),
        );
      });
  Widget get taxID => ControlledWidgetBuilder<SaveSupplierController>(
      builder: (context, controller) {
        return TextFormField(
          controller: controller.taxIDTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_tax_ID),
        );
      });
  Widget get bankDetails => ControlledWidgetBuilder<SaveSupplierController>(
      builder: (context, controller) {
        return TextFormField(
          controller: controller.bankDetailsTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_bank_details),
        );
      });
}
