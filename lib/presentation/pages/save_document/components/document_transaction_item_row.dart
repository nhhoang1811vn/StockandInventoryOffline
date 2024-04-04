import 'dart:io';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';

class DocumentTransactionItemRow extends StatelessWidget {
  final DocumentTransaction item;
  final void Function(DocumentTransaction item) onTransactionPressed;
  final void Function(DocumentTransaction item) onTransactionLongPressed;
  final bool isSelection;

  DocumentTransactionItemRow(
      this.item, this.onTransactionPressed, this.onTransactionLongPressed,
      [this.isSelection = false]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTransactionPressed(item),
      onLongPress : () => onTransactionLongPressed(item),
      child: Padding(padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), child: Row(children: [
        _buildLeadingWidget(),
        SizedBox(width: 8,),
        Expanded(child: _buildWidget())
      ],),),);
  }
  Widget _buildLeadingWidget(){
    return item.good.files.isNotEmpty
        ? getAvatarWidget(item.good.files.first)
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
          Text(item.good.name, style: AppStyle.getTitleListTitleStyle()),
          SizedBox(height: 4),
          if (item.good.barCode != null)
            Row(children: [
              Icon(UIConstants.barcodeIconData, size: 24,color: UIConstants.primaryColor),
              SizedBox(
                width: 8,
              ),
              Text(item.good.barCode!, style: AppStyle.getSubTitleListTitleStyle())
            ]),
          if (item.good.description.isNotEmpty)
            Column(children: [
              SizedBox(height: 4,),
              Text(item.good.description, style: AppStyle.getSubTitleListTitleStyle())
            ],)


        ]),),

        Text(item.quantity.toString(), style: AppStyle.getTrailingListTitleStyle(),)
      ],
    );
  }
  Widget _buildBottom(){
    //var price = 0.0;
    var leftValue = "";
    var rightValue = "";
    if (item.price == null){
      leftValue = Config.currencyFormat.format(0.0);
      rightValue = Config.currencyFormat.format(0.0);
    }else{
      leftValue = Config.currencyFormat.format(item.price!);
      rightValue = Config.currencyFormat.format(item.price!* item.quantity);
    }
    return Align(alignment: Alignment.centerRight, child: Text("$leftValue / $rightValue"));
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
