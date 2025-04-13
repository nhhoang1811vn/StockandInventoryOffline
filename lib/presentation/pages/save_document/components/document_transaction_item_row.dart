import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/utils.dart';

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
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onTransactionPressed(item),
        onLongPress : () => onTransactionLongPressed(item),
        child: Padding(padding: EdgeInsets.all(16.0), child: Row(children: [
          _buildLeadingWidget(context),
          SizedBox(width: 8,),
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
      _buildBottom()
    ],);
  }
  Widget _buildTop(BuildContext context){
    return Row(
      children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text(item.good.name, style:
          Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
          SizedBox(height: 4),
          if (item.good.barCode != null)
            Row(children: [
              Icon(UIConstants.barcodeIconData, size: 24,color: UIConstants.primaryColor),
              SizedBox(
                width: 8,
              ),
              Text(item.good.barCode!, style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onSurface))
            ]),
          if (item.good.description.isNotEmpty)
            Column(children: [
              SizedBox(height: 4,),
              Text(item.good.description, style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onSurface))
            ],)


        ]),),

        Text(Utils.getQuantityText(item.quantity), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),)
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
  Widget getAvatarWidget(Uint8List bytes) {
    return SizedBox(width: 48, height: 48, child: Image.memory(bytes));
  }
  Widget _buildEmptyAvatarWidget(BuildContext context){
    return Icon(UIConstants.goodIconData, size: 32, color: Theme.of(context).colorScheme.onPrimary);
  }
}
