import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/stores/save_store_page.dart';
import 'package:good_manager/app/pages/stores/stores_presenter.dart';
import 'package:good_manager/domain/entities/Store.dart';

class StoreList extends StatelessWidget{
  List<Store> stores;
  StoresPresenter presenter;

  StoreList(
      List<Store> this.stores,
      StoresPresenter this.presenter, {
        Key key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stores == null || stores.isEmpty){
      return Center(child: Text(AppLocalizations.of(context).empty_stores),);
    }else{
      return new ListView.separated(
        itemCount: stores.length,
        itemBuilder: (BuildContext context, int index){
          //return new Text(stores[index].name);
          return ListTile(
            title: Text(stores[index].name),
            subtitle: Text(stores[index].description),
            onTap: () => onStoreTapped(context,stores[index]),
            onLongPress: () => onLongPressStore(context,stores[index]),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },


      );
    }
  }
  void onStoreTapped(BuildContext context,Store store) async{
   /* final result = await Navigator.of(context).pushNamed(
        SaveStorePageWidget.routeName,
        arguments: SaveStorePageArguments(false, store));
    if (result){
      presenter.refresh();
    }*/
  }
  void onLongPressStore(BuildContext context,Store store){
    showDialog(context: context,
        builder: (context) => AlertDialog(
        title: Text(""),

    ));
  }
}