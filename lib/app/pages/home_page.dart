import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'documents/documents_page.dart';
import 'goods/goods_page.dart';
import 'more/more_page.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    GoodsPageWidget(),
    DocumentsPage(),
    MorePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined),
              label: 'Giao dịch'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Khác'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}