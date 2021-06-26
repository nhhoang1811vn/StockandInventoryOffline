import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/app/pages/save_good/save_good_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_document_transaction_repository.dart';
import 'package:good_manager/data/repositories/data_good_repository.dart';
import 'package:good_manager/domain/entities/good.dart';

class SaveGoodPage extends View {
  final Good item;
  final int quantity;

  SaveGoodPage(this.item, [this.quantity]) : super();

  @override
  SaveGroupPageView createState() => SaveGroupPageView(item, quantity);
}

class SaveGroupPageView extends ViewState<SaveGoodPage, SaveGoodController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SaveGroupPageView(item, quantity)
      : super(SaveGoodController(DataGoodRepository(),
      DataDocumentTransactionRepository(), item, quantity));

  @override
  Widget get view => Scaffold(
      key: globalKey,
      appBar: appBar,
      body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.screenSpace,
              vertical: UIConstants.screenSpace),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    name,
                    description,
                    barCode,
                    ControlledWidgetBuilder<SaveGoodController>(
                        builder: (context, controller) {
                      return Visibility(
                        child: quantity,
                        visible: controller.quantity != null,
                      );
                    })
                  ],
                ),
              ),
              Container(
                  child: Text(AppLocalizations.of(context).field_attachments),
                  margin: const EdgeInsets.only(top: 8)),
              addFileButton,
              filesView
            ],
          )));

  Widget get appBar => AppBar(
      title: Text(AppLocalizations.of(context).title_save_goods),
      actions: <Widget>[
        ControlledWidgetBuilder<SaveGoodController>(
            builder: (context, controller) {
              return Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                      onTap: () => controller.checkForm({
                        'context': context,
                        'formKey': _formKey,
                        'globalKey': globalKey
                      }),
                      child: Icon(Icons.check, size: 26)));
            })
      ]);

  Widget get name => ControlledWidgetBuilder<SaveGoodController>(
      builder: (context, controller) {
        return TextFormField(
            controller: controller.nameTextController,
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

  Widget get description => ControlledWidgetBuilder<SaveGoodController>(
      builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });

  Widget get barCode => ControlledWidgetBuilder<SaveGoodController>(
      builder: (context, controller) {
        return Row(
          children: [
            Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).field_bar_code),
                  controller: controller.barCodeTextController,
                )),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(FontAwesomeIcons.barcode, size: 28),
                    onPressed: controller.onInputBarCodePressed))
          ],
        );
      });

  Widget get quantity => ControlledWidgetBuilder<SaveGoodController>(
      builder: (context, controller) {
        return Row(
          children: [
            Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).field_quantity),
              controller: controller.quantityTextController,
            )),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(UIConstants.calculatorIconData, size: 28),
                    onPressed: controller.onInputQuantityPressed))
          ],
        );
      });

  Widget get addFileButton => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return OutlinedButton(
          //style: outlineButtonStyle,
          onPressed: controller.onAddFile,
          child: Text(AppLocalizations.of(context).action_add_attachment),
        );
      });

  Widget get filesView => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return Container(
          child: ListView.builder(
              itemBuilder: (context, position) {
                return ListTile(
                  leading: getLeadingFile(controller.files[position]),
                  title: getTitleFile(controller.files[position]),
                );
              },
              itemCount: controller.files.length,
              scrollDirection: Axis.vertical),
          width: 400,
          height: 500,
        );
      });

  Widget getLeadingFile(String path) {
    return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            image:
                DecorationImage(image: FileImage(File(path)), fit: BoxFit.fill))
        //  child: Image.file(file),
        );
  }

  Widget getTitleFile(String path) {
    //var path = file.path;
    var fileName = (path.split('/').last);
    return Text(fileName);
  }
}
