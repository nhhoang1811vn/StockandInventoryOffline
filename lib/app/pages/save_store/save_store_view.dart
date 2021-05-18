import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/data/repositories/data_store_repository.dart';
import 'package:good_manager/domain/entities/store.dart';

import 'save_store_controller.dart';

class SaveStorePage extends View {
  final Store store;
  final bool isInsert;

  SaveStorePage({Key key, this.store, @required this.isInsert})
      : super(key: key);

  @override
  _SaveStorePageView createState() => _SaveStorePageView(store, isInsert);
}

class _SaveStorePageView extends ViewState<SaveStorePage, SaveStoreController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _SaveStorePageView(store, isInsert)
      : super(SaveStoreController(DataStoreRepository(), store, isInsert));

  @override
  Widget get view => Scaffold(
      key: globalKey,
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).save_store_title),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: ControlledWidgetBuilder<SaveStoreController>(
                  builder: (context, controller) {
                return GestureDetector(
                    onTap: () => controller.checkForm({
                          'context': context,
                          'formKey': _formKey,
                          'globalKey': globalKey
                        }),
                    child: Icon(Icons.check, size: 26));
              }),
            )
          ]),
      body: ListView(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[name, description],
                ),
              ))
        ],
      ));

  Widget get name => ControlledWidgetBuilder<SaveStoreController>(
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

  Widget get description => ControlledWidgetBuilder<SaveStoreController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });
}
