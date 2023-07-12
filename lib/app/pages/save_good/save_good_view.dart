/*
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base/base_page.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'bloc/save_good_cubit.dart';
import 'bloc/save_good_data.dart';

class SaveGoodPage extends StatefulWidget {
  final Good item;
  final bool enableAddTransactions;

  SaveGoodPage(this.item, this.enableAddTransactions) : super();

  @override
  State<SaveGoodPage> createState() => SaveGoodPageState();
}

class SaveGoodPageState extends BasePageState<SaveGoodPage, SaveGoodCubit, SaveGoodData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget buildPage(BuildContext context, SaveGoodData data) {
    return WillPopScope(
        child: Scaffold(
          //key: globalKey,
          appBar: appBar,
          body: Column(
            children: [
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
                        _buildName(data),
                        SizedBox(height: 12),
                        _buildDescription(data),
                        SizedBox(height: 12),
                        _buildBarCode(data),
                        SizedBox(height: 12),
                        _buildQuantity(data),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.field_images,
                            style: TextStyle(color: UIConstants.primaryColor, fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 12),
                        //ImagesPreviewView(controller.files, true,
                        //    controller.onImagesChanged)
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
        onWillPop: cubit.onWillPop);
  }

  Widget get appBar => AppBar(title: Text(AppLocalizations.of(context)!.save_goods_title), actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(onTap: () => {}, child: Icon(Icons.check, size: 26)))
      ]);

  Widget _buildName(SaveGoodData data) {
    return TextFormField(
        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.field_name),
        validator: (String value) {
          if (value.trim().isEmpty) {
            return AppLocalizations.of(context)!.message_name_blank;
          } else {
            return null;
          }
        });
  }

  Widget _buildDescription(SaveGoodData data) {
    return TextFormField(
      //controller: controller.descriptionTextController,
      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.field_desc),
    );
  }

  Widget _buildBarCode(SaveGoodData data){
    return Row(
          children: [
            Expanded(
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.field_bar_code),
                    //controller: controller.barCodeTextController
                )),
            Align(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  minWidth: 24,
                  //onPressed: controller.onInputBarCodePressed,
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
      }

  Widget _buildAddQuantityButton(SaveGoodData data) {
        return MaterialButton(
          minWidth: 24,
          //onPressed: () => controller.onAddQuantityButtonPressed({'context': context, 'formKey': _formKey, 'globalKey': globalKey}),
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.add,
            size: 24,
          ),
          padding: EdgeInsets.all(8),
          shape: CircleBorder(),
        );
      }

  Widget _buildSubQuantityButton(SaveGoodData data){
        return MaterialButton(
          minWidth: 24,
          //onPressed: () => controller.onSubQuantityButtonPressed({'context': context, 'formKey': _formKey, 'globalKey': globalKey}),
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.remove,
            size: 24,
          ),
          padding: EdgeInsets.all(8),
          shape: CircleBorder(),
        );
      }

  Widget _buildModifyQuantityButton(SaveGoodData data){
        return MaterialButton(
          minWidth: 24,
          //onPressed: controller.onModifyQuantityButtonPressed,
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.calculate_outlined,
            size: 24,
          ),
          padding: EdgeInsets.all(8),
          shape: CircleBorder(),
        );
      }

  Widget _buildQuantity(SaveGoodData data){
        return Row(
          children: [
            Expanded(
                child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.field_quantity),
              //controller: controller.quantityTextController,
            )),
            Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    if (widget.enableAddTransactions) _buildAddQuantityButton(data),
                    if (widget.enableAddTransactions) _buildSubQuantityButton(data),
                    if (!widget.enableAddTransactions) _buildModifyQuantityButton(data)
                  ],
                ))
          ],
        );
      }
}
*/
