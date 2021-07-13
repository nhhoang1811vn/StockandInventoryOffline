import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/expenses/expenses_view.dart';
import 'package:good_manager/app/pages/home/home_view.dart';
import 'package:good_manager/app/utils/constants.dart';

import 'documents/documents_view.dart';
import 'goods/goods_view.dart';
import 'more/more_view.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    GoodsPage(isSelection: false),
    DocumentsPage(),
    ExpensesPage(),
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
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              UIConstants.homeIconPath,
              width: 24,
            ),
            label: AppLocalizations.of(context).home_title,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              UIConstants.goodIconPath,
              width: 24,
            ),
            label: AppLocalizations.of(context).goods_title,
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                UIConstants.documentIconPath,
                width: 24,
              ),
              label: AppLocalizations.of(context).documents_title),
          BottomNavigationBarItem(
              icon: Image.asset(
                UIConstants.expenseIconPath,
                width: 24,
              ),
              label: AppLocalizations.of(context).expenses_title),
          BottomNavigationBarItem(
              icon: Icon(UIConstants.moreIconData),
              label: AppLocalizations.of(context).more_title),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}