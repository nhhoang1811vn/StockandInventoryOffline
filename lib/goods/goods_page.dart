import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:good_manager/goods/goods_presenter.dart';
import 'package:good_manager/goods/save_good.dart';
import 'package:good_manager/goods/save_group.dart';
import 'package:good_manager/model/Good.dart';
import 'package:good_manager/model/GoodItem.dart';
import 'package:good_manager/model/Group.dart';
import 'package:good_manager/utils/AppUtils.dart';

import 'list.dart';

class GoodsPageWidget extends StatefulWidget {
  GoodsPageWidget({Key key}) : super(key: key);

  @override
  State<GoodsPageWidget> createState() {
    return _GoodPageWidgetState();
  }
}

class _GoodPageWidgetState extends State<GoodsPageWidget>
    implements GoodsContract {
  GoodsPresenter presenter;
  SearchBar searchBar;
  List<Group> selectedGroups = [];

  @override
  void initState() {
    presenter = GoodsPresenter(this);
    searchBar = new SearchBar(
        inBar: true,
        setState: setState,
        //onSubmitted: onSubmitted,
        //onChanged: onChanged,
        buildDefaultAppBar: buildAppBar,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
    super.initState();
  }

  void _onAddGood() async {
    Good item = Good();
    item.groupId = getSelectedGroupId();
    item.storeId = await AppUtils.getSelectedStoreId();

    SaveGoodPageArguments arguments = SaveGoodPageArguments();
    arguments.good = item;
    final result = await Navigator.of(context).pushNamed(
        SaveGoodPageWidget.routeName,
        arguments: arguments);
    if (result) {
      screenUpdated();
    }
  }

  void _onAddGroup() async {
    Group item = Group();
    item.groupId = getSelectedGroupId();
    item.storeId = await AppUtils.getSelectedStoreId();
    final result = await Navigator.of(context).pushNamed(
        SaveGroupPageWidget.routeName,
        arguments: SaveGroupPageArguments(true, item));
    if (result) {
      screenUpdated();
    }
  }

  int getSelectedGroupId() {
    if (selectedGroups.isEmpty) {
      return null;
    } else {
      return selectedGroups.last.id;
    }
  }


  AppBar buildAppBar(BuildContext context) {
    return new AppBar(title: new Text('Sản phẩm'), actions: [
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

  void _onSortMenuItemTapped() {
    /*showDialog(context: context, builder: (_) => SortByStoreDialogWidget(()=>{
      screenUpdated()
    }), barrierDismissible: false);*/
  }

  void _onHelpMenuItemTapped() {
    //Navigator.of(context).pushNamed(HelpPageWidget.routeName, arguments: HelpPageArguments("content man hinh store"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Column(children: [
        Container(
            color: Colors.blue[800],
            width: double.infinity,
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(top: 4, bottom: 4),
                child:
                    Text('main store', style: TextStyle(color: Colors.white)))),
        Visibility(
          visible: selectedGroups.isNotEmpty,
          child: Container(
            height: 40,
            color: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedGroups.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(children: [
                    GestureDetector(
                        child: Icon(Icons.home, color: Colors.white),
                        onTap: () => onSelectedGroupTapped(-1)),
                    GestureDetector(
                        child: Row(children: [
                          Icon(Icons.navigate_next, color: Colors.white),
                          Text(selectedGroups[index].name,
                              style: TextStyle(color: Colors.white))
                        ]),
                        onTap: () => onSelectedGroupTapped(0))
                  ]);
                } else {
                  return GestureDetector(
                      child: Row(children: [
                        Icon(Icons.navigate_next, color: Colors.white),
                        Text(selectedGroups[index].name,
                            style: TextStyle(color: Colors.white))
                      ]),
                      onTap: () => onSelectedGroupTapped(index));
                }
              },
            ),
          ),
        ),
        Expanded(
            child: new FutureBuilder<List<GoodItem>>(
          future: presenter.getItems(getSelectedGroupId()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new GoodItemList(snapshot.data, onGroupTapped, onGoodTapped)
                : new Center(child: new CircularProgressIndicator());
          },
        )),
      ]),
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        /// This is ignored if animatedIcon is non null
        icon: Icons.add,
        activeIcon: Icons.remove,
        // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
        /// The label of the main button.
        // label: Text("Open Speed Dial"),
        /// The active label of the main button, Defaults to label if not specified.
        // activeLabel: Text("Close Speed Dial"),
        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
        buttonSize: 56.0,
        visible: true,

        /// If true user is forced to close dial manually
        /// by tapping main button and overlay is not rendered.
        closeManually: false,

        /// If true overlay will render no matter what.
        renderOverlay: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        // orientation: SpeedDialOrientation.Up,
        // childMarginBottom: 2,
        // childMarginTop: 2,
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.create_new_folder,
                color: Colors.white,
              ),
              backgroundColor: Colors.yellowAccent,
              label: 'Tạo nhóm',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => _onAddGroup()),
          SpeedDialChild(
              child: Icon(Icons.note_add, color: Colors.white),
              backgroundColor: Colors.redAccent,
              label: 'Tạo hàng hoá',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => _onAddGood())
        ],
      ),
    );
  }

  @override
  void screenUpdated() {
    setState(() {});
  }

  void onSelectedGroupTapped(int index) {
    if (index == -1) {
      selectedGroups.clear();
    } else {
      selectedGroups = selectedGroups.sublist(0, index + 1);
    }
    screenUpdated();
  }

  void onGroupTapped(Group group) {
    selectedGroups.add(group);
    screenUpdated();
  }

  void onGoodTapped(Good good) async {
    SaveGoodPageArguments arguments = SaveGoodPageArguments();
    arguments.good = good;
    final result = await Navigator.of(context).pushNamed(
        SaveGoodPageWidget.routeName,
        arguments: arguments);
    if (result) {
      screenUpdated();
    }
  }
}
