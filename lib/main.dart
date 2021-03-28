import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/documents/save_document.dart';
import 'package:good_manager/goods/goods_page.dart';
import 'package:good_manager/help/help_page_dart.dart';
import 'package:good_manager/stores/save_store_page.dart';
import 'package:good_manager/stores/save_store_presenter.dart';
import 'package:good_manager/stores/stores_page.dart';
import 'package:good_manager/stores/stores_presenter.dart';
import 'package:good_manager/suppliers/save_supplier_page.dart';
import 'package:good_manager/suppliers/suppliers_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:good_manager/assets/constants.dart' as Constants;



import 'documents/documentns_page.dart';
import 'goods/save_good.dart';
import 'goods/save_group.dart';
import 'model/Store.dart';
import 'more/more_page.dart';
import 'onboarding/OnBoardingPage.dart';
import 'package:good_manager/assets/constants.dart' as Constants;

bool firstTime;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstTime = await prefs.getBool(Constants.KEY_FIRST_TIME);
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
      //initialRoute: firstTime?"first":"/",
      routes: <String, WidgetBuilder>{
        StoresPageWidget.routeName : (BuildContext context) => StoresPageWidget(),
        SaveStorePageWidget.routeName: (BuildContext context) => SaveStorePageWidget(),
        SuppliersPageWidget.routeName : (BuildContext context) => SuppliersPageWidget(),
        SaveSupplierPageWidget.routeName : (BuildContext context) => SaveSupplierPageWidget(),
        SaveGoodPageWidget.routeName : (BuildContext context) => SaveGoodPageWidget(),
        SaveGroupPageWidget.routeName : (BuildContext context) => SaveGroupPageWidget(),
        HelpPageWidget.routeName : (BuildContext context) => HelpPageWidget(),
        SaveDocumentPageWidget.routeName : (BuildContext context) => SaveDocumentPageWidget(),

      },

      home: (firstTime == null)?OnBoardingPage():MainPageWidget(),
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
    DocumentPageWidget(),
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