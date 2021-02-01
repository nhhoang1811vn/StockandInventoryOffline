import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/goods/goods_page.dart';
import 'package:good_manager/stores/save_store_page.dart';
import 'package:good_manager/stores/stores_page.dart';
import 'package:good_manager/suppliers/save_supplier_page.dart';
import 'package:good_manager/suppliers/suppliers_page.dart';



import 'goods/save_good.dart';
import 'more/more_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        StoresPageWidget.routeName : (BuildContext context) => StoresPageWidget(),
        SaveStorePageWidget.routeName: (BuildContext context) => SaveStorePageWidget(),
        SuppliersPageWidget.routeName : (BuildContext context) => SuppliersPageWidget(),
        SaveSupplierPageWidget.routeName : (BuildContext context) => SaveSupplierPageWidget(),
        SaveGoodPageWidget.routeName : (BuildContext context) => SaveGoodPageWidget()
      },

      home: MainPageWidget(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: AppLocalizations.supportedLocales
,
      // ...,
    );
  }
}

class MainPageWidget extends StatefulWidget{
  MainPageWidget({Key key}) : super(key: key);

  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}
class _MainPageWidgetState extends State<MainPageWidget>{
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    GoodsPageWidget(),
    GoodsPageWidget(),
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
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).home_menu_item_documents),
        ),
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              label: AppLocalizations.of(context).home_menu_item_goods,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined),
              label: AppLocalizations.of(context).home_menu_item_documents,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: AppLocalizations.of(context).home_menu_item_more
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    }
}