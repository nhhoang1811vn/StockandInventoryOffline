import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:good_manager/app/pages/stores/stores_controller.dart';
import 'package:good_manager/data/repositories/data_store_repository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StoresPage extends View {
  StoresPage({Key key}) : super(key: key);

  @override
  _StoresPageView createState() => _StoresPageView();
}

class _StoresPageView extends ViewState<StoresPage, StoresController> {
  _StoresPageView() : super(StoresController(DataStoreRepository())) {
    searchBar = new SearchBar(
        inBar: true,
        setState: setState,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        buildDefaultAppBar: buildAppBar,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  SearchBar searchBar;
  var textSearch = "";
  SharedPreferences sharedPrefs;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(AppLocalizations
            .of(context)
            .stores_title),
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
          ControlledWidgetBuilder<StoresController>(
              builder: (context, controller) {
                return Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => controller.openHelpPage(),
                    child: Icon(
                      Icons.help,
                      size: 26,
                    ),
                  ),
                );
              })

        ]);
  }

  void onSubmitted(String value) {
    //setState(() => _scaffoldKey.currentState
    //     .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }

  void onChanged(String value) {
    setState(() => {textSearch = value});
  }


  void _onSortMenuItemTapped() {
    /*showDialog(context: context, builder: (_) => SortByStoreDialogWidget(()=>{
      screenUpdated()
    }), barrierDismissible: false);*/
  }

  @override
  Widget get view =>
      Scaffold(
          key: globalKey,
          appBar: searchBar.build(context),
          body: ControlledWidgetBuilder<StoresController>(
              builder: (context, controller) {
                return ModalProgressHUD(
                    child: getListView(),
                    inAsyncCall: controller.isLoading,
                    opacity: 0);
              })
          ,
          floatingActionButton: ControlledWidgetBuilder<StoresController>(
              builder: (context, controller) {
                return FloatingActionButton(
                  onPressed: () => controller.onAddStore(),
                  child: Icon(Icons.add),
                );
              }));

  Widget getListView() {
    return ControlledWidgetBuilder<StoresController>(
        builder: (context, controller) {
          return ListView.separated(
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  title: Text(controller.stores[index].name),
                  subtitle: Text(controller.stores[index].description),
                  onTap: () => controller.onEditStore(controller.stores[index]),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: controller.stores.length);
        });
  }
}
