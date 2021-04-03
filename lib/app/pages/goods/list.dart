import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/Good.dart';
import 'package:good_manager/domain/entities/GoodItem.dart';
import 'package:good_manager/domain/entities/Group.dart';
class GoodList extends StatelessWidget {
  List<Good> items;
  final void Function(Good good) onGoodTapped;
  final void Function(Good good) onGoodLongPressed;

  GoodList(this.items, this.onGoodTapped, this.onGoodLongPressed);

  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty) {
      return Center(child: Text('Không có sản phẩm'),);
    } else {
      return new ListView.separated(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(items[index].name, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
              subtitle: Text(items[index].description),
              trailing: Text(items[index].quantity.toString()),
              leading: Icon(Icons.image, size: 36,color: Colors.blue),
              onTap: () => onGoodTapped(items[index]),
              onLongPress: () => onGoodLongPressed(items[index]),
            );
          }, separatorBuilder: (context, index) {
        return Divider();
      },);
    }
  }
}
class GoodItemList extends StatelessWidget{
  List<GoodItem> items;
  final void Function(Group group) onGroupTapped;
  final void Function(Good good) onGoodTapped;
  GoodItemList(this.items, this.onGroupTapped, this.onGoodTapped);
  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty){
      return Center(child: Text('Không có sản phẩm'),);
    }else{
      return new ListView.separated(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index){
          if (items[index].group != null){
            return ListTile(
              title: Text(items[index].group.name),
              subtitle: Text(items[index].group.description),
              trailing: Text(items[index].quality.toString()),
              leading: Icon(Icons.folder),
              onTap: () => onGroupTapped(items[index].group),
              //onLongPress: () => onLongPressStore(context,stores[index]),
            );
          }else{
            return ListTile(
              title: Text(items[index].good.name, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
              subtitle: Text(items[index].good.description),
              trailing: Text(items[index].quality.toString()),
              leading: Icon(Icons.image, size: 36,color: Colors.blue),
              onTap: () => onGoodTapped(items[index].good),
              //onLongPress: () => onLongPressStore(context,stores[index]),
            );
          }

        },
        separatorBuilder: (context, index) {
          return Divider();
        },


      );
    }
  }

}