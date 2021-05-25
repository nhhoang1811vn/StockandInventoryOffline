import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';

import 'documents/documents_view.dart';
import 'goods/goods_view.dart';
import 'more/more_view.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    GoodsPage(),
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
            icon: Icon(UIConstants.goodsIconData),
            label: AppLocalizations
                .of(context)
                .title_goods,
          ),
          BottomNavigationBarItem(
              icon: Icon(UIConstants.documentsIconData),
              label: AppLocalizations
                  .of(context)
                  .title_document
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: AppLocalizations
                  .of(context)
                  .title_more
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}