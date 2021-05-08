import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_controller.dart';
import 'package:good_manager/data/repositories/data_supplier_repository.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';


class SuppliersPage extends View {
  final bool isSelection;
  SuppliersPage({Key key, @required this.isSelection});
  @override
  SuppliersPageView createState() => SuppliersPageView(isSelection);

}

class SuppliersPageView extends ViewState<SuppliersPage, SuppliersController> {
  SearchBar searchBar;
  var textSearch = "";

  SuppliersPageView(isSelection) : super(SuppliersController(DataSupplierRepository(), isSelection)){
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
  Widget get view => Scaffold(
      key: globalKey,
      appBar: searchBar.build(context),
      body: ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
            return ModalProgressHUD(
                child: getListView(),
                inAsyncCall: controller.isLoading,
                opacity: 0);
          })
      ,
      floatingActionButton: ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
            return FloatingActionButton(
              onPressed: () => controller.onAddItem(),
              child: Icon(Icons.add),
            );
          }));

  Widget getListView() {
    return ControlledWidgetBuilder<SuppliersController>(
        builder: (context, controller) {
          return  ListView.separated(
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  title: Text(controller.suppliers[index].name),
                  subtitle: Text(controller.suppliers[index].description),
                  onTap: () => controller.onItemPressed(controller.suppliers[index]),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: controller.suppliers.length);
        });
  }

  void onSearchBarChanged(String value) {
    setState(() => {textSearch = value});
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(AppLocalizations.of(context).suppliers_title),
        actions: [
          searchBar.getSearchAction(context),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(
                Icons.sort_by_alpha,
                size: 26,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(
                Icons.help,
                size: 26,
              ),
            ),
          )
        ]);
  }
}
