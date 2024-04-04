import 'dart:io';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';

class GoodItemRow extends StatelessWidget {
  final Good item;
  final double quantity;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;
  final bool isSelection;

  GoodItemRow(
      this.item, this.quantity, this.onGoodTapped, this.onGoodLongPressed,
      [this.isSelection = false]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onGoodTapped(item),
      onLongPress : () => onGoodLongPressed(item),
      child: Padding(padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), child: Row(children: [
        _buildLeadingWidget(),
        SizedBox(width: 8,),
        Expanded(child: _buildWidget())
      ],),),);
  }
  Widget _buildLeadingWidget(){
    return item.files.isNotEmpty
        ? getAvatarWidget(item.files.first)
        : _buildEmptyAvatarWidget();
  }
  Widget _buildWidget(){
    return Column(children: [
      _buildTop(),
      _buildBottom()
    ],);
  }
  Widget _buildTop(){
    return Row(
      children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text(item.name, style: AppStyle.getTitleListTitleStyle()),
          SizedBox(height: 4),
          if (item.barCode != null)
            Row(children: [
              Icon(UIConstants.barcodeIconData, size: 24,color: UIConstants.primaryColor),
              SizedBox(
                width: 8,
              ),
              Text(item.barCode!, style: AppStyle.getSubTitleListTitleStyle())
            ]),
          if (item.description.isNotEmpty)
            Column(children: [
              SizedBox(height: 4,),
              Text(item.description, style: AppStyle.getSubTitleListTitleStyle())
            ],)


        ]),),

        Text(item.quantity.toString(), style: AppStyle.getTrailingListTitleStyle(),)
      ],
    );
  }
  Widget _buildBottom(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(Config.currencyFormat.format(item.purchasePrice??0), style: TextStyle(color: Palette.red)),
        Text("/"),
        Text(Config.currencyFormat.format(item.salePrice??0), style: TextStyle(color: Palette.green))
      ],
    );
  }

  Widget getAvatarWidget(String path) {
    return Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: FileImage(File(path)), fit: BoxFit.fill)));
  }

  Widget _buildEmptyAvatarWidget(){
    return SizedBox(width: 48, height: 48, child: Icon(UIConstants.goodIconData, size: 32,color: UIConstants.primaryColor));
  }
}
