import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_good/save_good_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/data/repositories/data_good_repository.dart';
import 'package:good_manager/domain/entities/good.dart';

import '../../widgets/images_preview_view.dart';

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
  Widget get view => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return WillPopScope(
            child: Scaffold(
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
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context).field_images,
                                style: TextStyle(
                                    color: UIConstants.primaryColor,
                                    fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 12),
                           ImagesPreviewView(controller.files, true, controller.onImagesChanged)
                          ],
                        ),
                      ),
                    ],
                  ))
                ])),
            onWillPop: controller.onWillPop);
      });

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
}
