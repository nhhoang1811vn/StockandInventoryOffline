import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:good_manager/model/Supplier.dart';
import 'package:good_manager/suppliers/save_supplier_page.dart';
import 'package:good_manager/suppliers/suppliers_presenter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'list.dart';

class SuppliersPageWidget extends StatefulWidget {
  static const routeName = '/suppliers';

  @override
  State<StatefulWidget> createState() {
    return _SuppliersPageWidgetState();
  }
}

class _SuppliersPageWidgetState extends State<SuppliersPageWidget>
    implements SuppliersContract {
  SuppliersPresenter presenter;
  SearchBar searchBar;
  var textSearch = "";

  _SuppliersPageWidgetState() {
    searchBar = new SearchBar(
        inBar: true,
        setState: setState,
        //onSubmitted: onSubmitted,
        onChanged: onSearchBarChanged,
        buildDefaultAppBar: buildAppBar,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  void initState() {
    presenter = new SuppliersPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: new FutureBuilder<List<Supplier>>(
          future: presenter.getSuppliers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            var data = snapshot.data;
            List<Supplier> filterResults = [];
            data.forEach((element) {
              if (element.name.startsWith(textSearch)) {
                filterResults.add(element);
              }
            });
            return snapshot.hasData
                ? new SupplierList(filterResults, presenter)
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          }),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add',
          onPressed: _onAddItem,
          child: Icon(Icons.add),
        )
    );
  }

  void onSearchBarChanged(String value) {
    setState(() => {
      textSearch = value
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(AppLocalizations.of(context).suppliers_title),
        actions: [
          searchBar.getSearchAction(context),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _onSortMenuItemTapped,
              child: Icon(
                Icons.sort_by_alpha,
                size: 26,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _onHelpMenuItemTapped,
              child: Icon(
                Icons.help,
                size: 26,
              ),
            ),
          )
        ]);
  }

  void _onAddItem() async {
    final result = await Navigator.of(context).pushNamed(
        SaveSupplierPageWidget.routeName,
        arguments: SaveSupplierPageArguments(true, Supplier("", "")));
    if (result) {
      //save success, update list
      setState(() {

      });
    }
  }

  void _onSortMenuItemTapped() {}

  void _onHelpMenuItemTapped() {}

  @override
  void screenUpdated() {}
}
