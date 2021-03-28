import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/model/Store.dart';
import 'package:good_manager/model/Supplier.dart';
import 'package:good_manager/stores/save_store_page.dart';
import 'package:good_manager/stores/stores_presenter.dart';
import 'package:good_manager/suppliers/save_supplier_page.dart';
import 'package:good_manager/suppliers/suppliers_presenter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            title: Text(items[index].name),
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