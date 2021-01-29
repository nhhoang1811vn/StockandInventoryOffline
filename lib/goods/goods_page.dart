import 'package:flutter/material.dart';
import 'package:good_manager/goods/save_good.dart';

class GoodsPageWidget extends StatefulWidget {
  GoodsPageWidget({Key key}) : super(key: key);

  @override
  State<GoodsPageWidget> createState() {
    return _GoodPageWidgetState();
  }
}

class _GoodPageWidgetState extends State<GoodsPageWidget> {
  void _onAddGood(){
    Navigator.of(context).pushNamed(SaveGoodPageWidget.routeName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry A')),
            ),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry B')),
            ),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add',
          onPressed: _onAddGood,
          child: Icon(Icons.add),
        ));
  }
}