import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_good/save_good_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/SelectedStoreView.dart';
import 'package:good_manager/data/repositories/data_good_repository.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:path/path.dart' as p;

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
      : super(SaveGoodController(DataGoodRepository(), item, quantity));

  @override
  Widget get view => Scaffold(
      key: globalKey,
      appBar: appBar,
      body: Column(children: [
        SelectedStoreView(),
        Expanded(
            child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(UIConstants.screenSpace),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  name,
                  SizedBox(height: 12),
                  description,
                  SizedBox(height: 12),
                  barCode,
                  SizedBox(height: 12),
                  quantity,
                  previewImage,
                  imageListView,
                ],
              ),
            ),
            /*Container(
                  child: Text(
                    AppLocalizations.of(context).field_attachments,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  margin: const EdgeInsets.only(top: 16)),
              Container(
                  child: addFileButton, margin: const EdgeInsets.only(top: 12)),
              filesView*/
          ],
        ))
      ]));

  Widget get appBar => AppBar(
          title: Text(AppLocalizations.of(context).save_goods_title),
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

  Widget get description => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });

  Widget get addPhotoButton => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return MaterialButton(
          minWidth: 24,
          onPressed: controller.onAddPhotoPressed,
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.add_photo_alternate_outlined,
            size: 24,
          ),
          padding: EdgeInsets.all(8),
          shape: CircleBorder(),
        );
      });

  Widget get takePhotoButton => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return MaterialButton(
          minWidth: 24,
          onPressed: controller.onTakePhotoPressed,
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 24,
          ),
          padding: EdgeInsets.all(8),
          shape: CircleBorder(),
        );
      });

  Widget get barCode => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return Row(
          children: [
            Expanded(
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).field_bar_code),
                    controller: controller.barCodeTextController)),
            Align(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  minWidth: 24,
                  onPressed: controller.onInputBarCodePressed,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.barcode_reader,
                    size: 24,
                  ),
                  padding: EdgeInsets.all(8),
                  shape: CircleBorder(),
                ))
          ],
        );
      });

  Widget get quantity => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.quantity != null,
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).field_quantity),
                  controller: controller.quantityTextController,
                )),
                Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      minWidth: 24,
                      onPressed: controller.onInputQuantityPressed,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.calculate,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    ))
              ],
            ));
      });

  /*Widget get filesView => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return Container(
          child: ListView.builder(
              itemBuilder: (context, position) {
                String path = controller.files[position];
                return ListTile(
                  leading: getLeadingFile(path),
                  title: getTitleFile(path),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => controller.showConfirmDeleteFile(position),
                  ),
                  onTap: () => controller.openFile(path),
                );
              },
              itemCount: controller.files.length,
              scrollDirection: Axis.vertical),
          height: 500,
        );
      });*/
  Widget get previewImage => ControlledWidgetBuilder<SaveGoodController>(builder: (context, controller) {
    return controller.selectedImagePosition > -1?
      Container(
          width: 250,
          height: 250,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(controller.files[controller.selectedImagePosition])), fit: BoxFit.fill))
    ):SizedBox(height: 20.0);});

  Widget get imageListView => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      height: 80,
                      child: ListView.builder(
                          itemBuilder: (context, position) {
                            return GestureDetector(onTap: () => controller.onImagePressed(position),child:  Container(
                                margin: EdgeInsets.only(left: 4, right: 4),
                                width: 80,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                    border: position == controller.selectedImagePosition ? Border.all(color: Colors.blue) : null,
                                    image: DecorationImage(
                                        image: FileImage(File(controller.files[position])), fit: BoxFit.contain))
                            ));
                          },
                          itemCount: controller.files.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true))),
              Align(
                  alignment: Alignment.centerRight,
                  child: Column(children: [addPhotoButton, takePhotoButton]))
            ],
          ),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        );
      });

  Widget getLeadingFile(String path) {
    if (isImage(path)) {
      return Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              image: DecorationImage(
                  image: FileImage(File(path)), fit: BoxFit.fill))
          );
    } else {
      return Container(
        width: 40,
        height: 40,
        child: Icon(Icons.attach_file),
        //  child: Image.file(file),
      );
    }
  }

  bool isImage(String path) {
    final extension = p.extension(path);
    return (extension == ".jpg" || extension == ".jpeg" || extension == ".png");
  }

  Widget getTitleFile(String path) {
    var fileName = (path.split('/').last);
    return Text(fileName);
  }
}
