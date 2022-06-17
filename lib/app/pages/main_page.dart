import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/customers/customers_view.dart';
import 'package:good_manager/app/pages/expenses/expenses_view.dart';
import 'package:good_manager/app/pages/home/home_view.dart';
import 'package:good_manager/app/pages/settings/settings_view.dart';
import 'package:good_manager/app/pages/stores/stores_view.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_view.dart';
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
  int selectedIndex = 0;
  static Widget _homePage = HomePage();
  static Widget _goodsPage = GoodsPage(isSelection: false);
  static Widget _documentsPage = DocumentsPage();
  static Widget _expensesPage = ExpensesPage();
  static Widget _reportPage = ExpensesPage();
  static SuppliersPage _suppliersPage = SuppliersPage(isSelection: false);
  static Widget _customersPage = CustomersPage(isSelection: false);
  static Widget _storesPage = StoresPage(isSelection: false);


  static List<Widget> _widgetOptions = <Widget>[
    _homePage,
    _goodsPage,
    _documentsPage,
    _expensesPage,
    _reportPage,
    _suppliersPage,
    _customersPage,
    _storesPage,
    SettingsPage(),
  ];
  static List<Widget> _appbarOptions = <Widget>[
    AppBar(
      title: Text("AppViet Quan ly Kho"),
    ),
    AppBar(
      title: Text("AppViet Quan ly Kho"),
    ),
    AppBar(
      title: Text("AppViet Quan ly Kho"),
    ),
    AppBar(
      title: Text("AppViet Quan ly Kho"),
    ),
    AppBar(
      title: Text("AppViet Quan ly Kho"),
    ),
    AppBar(
      title: Text("Suppliers"),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(UIConstants.searchMenuIconData, size: 26, color: UIConstants.normalMenuColor),
            //onTap: _suppliersPage.,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(UIConstants.sortMenuIconData,
                size: 26, color: UIConstants.normalMenuColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(UIConstants.helpMenuIconData,
                size: 26, color: UIConstants.normalMenuColor),
          ),
        ),
      ],
    ),
    //  AppBar(title: Text(AppLocalizations.of(context).goods_title),),
  ];

  Widget getListTile(int index, String icon, String title) {
    return ListTile(
      leading: Image.asset(
        icon,
        width: 24,
      ),
      trailing: Visibility(
        child: Text("Selected"),
        visible: selectedIndex == index,
      ),
      title: Text(title),
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarOptions[selectedIndex],
      body: Container(child: _widgetOptions[selectedIndex]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            getListTile(0, UIConstants.homeIconPath,
                AppLocalizations.of(context).home_title),
            Divider(),
            getListTile(1, UIConstants.goodIconPath,
                AppLocalizations.of(context).goods_title),
            getListTile(2, UIConstants.documentIconPath,
                AppLocalizations.of(context).documents_title),
            getListTile(3, UIConstants.expenseIconPath,
                AppLocalizations.of(context).expenses_title),
            getListTile(4, UIConstants.reportIconPath,
                AppLocalizations.of(context).report_title),
            Divider(),
            getListTile(5, UIConstants.supplierIconPath,
                AppLocalizations.of(context).suppliers_title),
            getListTile(6, UIConstants.customerIconPath,
                AppLocalizations.of(context).customers_title),
            getListTile(7, UIConstants.storeIconPath,
                AppLocalizations.of(context).stores_title),
            Divider(),
            ListTile(
              leading: Image.asset(
                UIConstants.settingsIconPath,
                width: 24,
              ),
              title: Text(AppLocalizations.of(context).settings_title),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                UIConstants.settingsIconPath,
                width: 24,
              ),
              title: Text(
                  AppLocalizations.of(context).question_or_suggestion_title),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                UIConstants.settingsIconPath,
                width: 24,
              ),
              title:
                  Text(AppLocalizations.of(context).your_subscriptions_title),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                UIConstants.settingsIconPath,
                width: 24,
              ),
              title: Text("Help"),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                UIConstants.settingsIconPath,
                width: 24,
              ),
              title: Text("What's news"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
