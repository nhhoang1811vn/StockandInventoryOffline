import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/data/repositories/data_store_repository.dart';
import 'package:good_manager/domain/entities/Store.dart';

import 'save_store_controller.dart';


class SaveStorePage extends View {
  final Store store;
  final bool isInsert;

  SaveStorePage({Key key, @required this.store, @required this.isInsert}) : super(key: key);

  @override
  _SaveStorePageView createState() => _SaveStorePageView(store, isInsert);
}


class _SaveStorePageView extends ViewState<SaveStorePage, SaveStoreController> {
  _SaveStorePageView(store, isInsert)
      : super(SaveStoreController(DataStoreRepository(), store, isInsert));

  final _textKey = GlobalKey<FormState>();


  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget get view =>
      Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
              title: Text(AppLocalizations
                  .of(context)
                  .save_store_title),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: ControlledWidgetBuilder<SaveStoreController>(
                      builder: (context, controller) {
                        return GestureDetector(
                            onTap: () => controller.verify(),
                            child: Icon(Icons.check, size: 26)
                        );
                      }),

                )
              ]
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ControlledWidgetBuilder<SaveStoreController>(
                    builder: (context, controller) {
                      return TextFormField(
                        key: _textKey,
                        controller: controller.nameTextController,
                        decoration: InputDecoration(labelText: AppLocalizations
                            .of(context)
                            .field_name,
                            errorText: controller.validate
                                ? null
                                : 'Name can not be blank'),
                        onChanged: (text) {
                          /*setState(() {
                            if (text.isEmpty) {
                              _validate = false;
                            } else {
                              _validate = true;
                            }
                          });*/
                        },
                      );
                    }),
                ControlledWidgetBuilder<SaveStoreController>(
                    builder: (context, controller) {
                      return TextFormField(
                        controller: controller.descriptionTextController,
                        decoration: InputDecoration(labelText: AppLocalizations
                            .of(context)
                            .field_desc),
                      );
                    }),
              ],
            ),
          ));
}
