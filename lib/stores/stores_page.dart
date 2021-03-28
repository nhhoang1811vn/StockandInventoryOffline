import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:good_manager/help/help_page_dart.dart';
import 'package:good_manager/model/Store.dart';
import 'package:good_manager/stores/save_store_page.dart';
import 'package:good_manager/stores/sort_by_store_dialog.dart';
import 'package:good_manager/stores/stores_presenter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:good_manager/assets/constants.dart' as Constants;
import 'list.dart';



class StoresPageWidget extends StatefulWidget {
  StoresPageWidget({Key key}) : super(key: key);
  static const routeName  = '/stores';

  @override
  State<StoresPageWidget> createState() {
    return _StoresPageWidgetState();
  }
}

class _StoresPageWidgetState extends State<StoresPageWidget> implements StoresContract {
  StoresPresenter presenter;
  SearchBar searchBar;
  var textSearch = "";
  SharedPreferences sharedPrefs;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(AppLocalizations.of(context).stores_title),
        actions: [
          searchBar.getSearchAction(context),
          Padding(padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _onSortMenuItemTapped,
              child: Icon(Icons.sort_by_alpha, size: 26,),
            ),),
          Padding(padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _onHelpMenuItemTapped,
              child: Icon(Icons.help, size: 26,),
            ),)]
    );
  }
  void onSubmitted(String value) {
    //setState(() => _scaffoldKey.currentState
   //     .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }
  void onChanged(String value){
    setState(() => {
      textSearch = value
    });
  }

  _StoresPageWidgetState(){
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
        }
    );
  }

  @override
  void initState() {
    super.initState();
    presenter = new StoresPresenter(this);
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
    });
  }
  void _onAddStore() async{
    final result = await Navigator.of(context).pushNamed(
        SaveStorePageWidget.routeName,
        arguments: SaveStorePageArguments(true, Store("","")));
    if (result){
      //save success, update list
      setState(() {

      });
    }
  }
  void _onSortMenuItemTapped(){
    showDialog(context: context, builder: (_) => SortByStoreDialogWidget(()=>{
      screenUpdated()
    }), barrierDismissible: false);
  }
  void _onHelpMenuItemTapped(){
    Navigator.of(context).pushNamed(HelpPageWidget.routeName, arguments: HelpPageArguments("content man hinh store"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
        body: new FutureBuilder<List<Store>>(
          future: presenter.getStores(),
          builder: (context, snapshot){
            if (snapshot.hasError) print(snapshot.error);
            var data = snapshot.data;
            List<Store> filteredStores = [];
            data.forEach((element) { 
              if (element.name.startsWith(textSearch)){
                filteredStores.add(element);
              }
            });
            //sort
            SortBy an = EnumToString.fromString(SortBy.values,sharedPrefs.getString(Constants.KEY_SORT_BY_STORE));
            switch(an){
              case SortBy.sort_a_z:
                filteredStores.sort((a,b){
                  return a.name.compareTo(b.name);
                });
                break;
              case SortBy.sort_z_a:
                filteredStores.sort((a,b){
                  return b.name.compareTo(a.name);
                });
                break;
              default:
            }
            return snapshot.hasData
                ? new StoreList(filteredStores, presenter)
                : new Center(child: new CircularProgressIndicator(),);
          },
        )
        ,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add',
          onPressed: _onAddStore,
          child: Icon(Icons.add),
        ));
  }

  @override
  void screenUpdated() {
    setState(() {

    });
  }
}