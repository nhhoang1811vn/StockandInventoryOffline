import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

class SupplierList extends StatelessWidget{
  List<Supplier> items;

  final void Function(Supplier item) onItemTapped;
  SupplierList(
      List<Supplier> this.items,
      this.onItemTapped, {
        Key key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty){
      return Center(child: Text(AppLocalizations.of(context).empty_suppliers),);
    }else{
      return new ListView.separated(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index){
          //return new Text(stores[index].name);
          return ListTile(
            title: Text(items[index].supplierName),
            subtitle: Text(items[index].description),
            onTap: () => onItemTapped(items[index]),
            //onLongPress: () => onItemLongPressed(context,items[index]),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },


      );
    }
  }
}