import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';
class DocumentTransactionItemRow extends StatelessWidget {
  final DocumentTransaction item;
  final Color bgColor;
  final void Function(DocumentTransaction item) onTransactionPressed;
  final void Function(DocumentTransaction item) onTransactionLongPressed;
  final bool isSelection;

  DocumentTransactionItemRow(
      this.item, this.bgColor,this.onTransactionPressed, this.onTransactionLongPressed,
      [this.isSelection = false]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => onTransactionPressed(item),
        onLongPress : () => onTransactionLongPressed(item),
        child: Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16.0), child: Row(children: [
          _buildLeadingWidget(context),
          SizedBox(width: 16),
          Expanded(child: _buildWidget(context))
        ],),),),
    );
  }
  Widget _buildLeadingWidget(BuildContext context){
    return item.good.files.isNotEmpty
        ? getAvatarWidget(item.good.files.first)
        : _buildEmptyAvatarWidget(context);
  }
  Widget _buildWidget(BuildContext context){
    return Column(children: [
      _buildTop(context),
      _buildBottom(context)
    ],);
  }
  Widget _buildTop(BuildContext context){
    TextStyle? primaryTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    TextStyle? secondaryTextStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text(item.good.name, style: primaryTextStyle),
          SizedBox(height: 4),
          if (item.good.barCode != null)
            Row(children: [
              Icon(UIConstants.barcodeIconData, size: 24,color: Theme.of(context).colorScheme.primary),
              SizedBox(
                width: 8,
              ),
              Text(item.good.barCode!, style: secondaryTextStyle)
            ]),
          if (item.good.description.isNotEmpty)
            Column(children: [
              SizedBox(height: 4,),
              Text(item.good.description, style: secondaryTextStyle)
            ],)


        ]),),

        Text(Utils.getQuantityText(item.quantity), style: primaryTextStyle,)
      ],
    );
  }
  Widget _buildBottom(BuildContext context){
    TextStyle? secondaryTextStyle = Theme.of(context).textTheme.bodySmall;
    var leftValue = "";
    var rightValue = "";
    if (item.price == null){
      leftValue = Config.currencyFormat.format(0.0);
      rightValue = Config.currencyFormat.format(0.0);
    }else{
      leftValue = Config.currencyFormat.format(item.price!);
      rightValue = Config.currencyFormat.format(item.price!* item.quantity);
    }
    return Align(alignment: Alignment.centerRight, child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
        children: [
      Text(AppLocalizations.of(context)!.field_price + ": " + leftValue, style: secondaryTextStyle),
      Text(AppLocalizations.of(context)!.field_amount + ": " + rightValue, style: secondaryTextStyle),
    ]));
  }
  // Widget getAvatarWidget(Uint8List bytes) {
  //   return SizedBox(width: 36, height: 48, child: Image.memory(bytes, fit: BoxFit.cover,));
  // }
  Widget getAvatarWidget(Uint8List bytes) {
    return SizedBox(
      width: 36,
      height: 36,
      child: ClipOval(
        child: Image.memory(
          bytes,
          fit: BoxFit.cover, // Ensures the image covers the entire circular area
        ),
      ),
    );
  }
  Widget _buildEmptyAvatarWidget(BuildContext context){
    return Icon(UIConstants.goodIconData, size: 36, color: Theme.of(context).colorScheme.primary);
  }
}
