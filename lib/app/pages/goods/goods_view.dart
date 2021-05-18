import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_group_repository.dart';

import 'package:good_manager/domain/entities/group.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../pages.dart';
import 'goods_controller.dart';
import 'list.dart';

class GoodsPage extends View {
  GoodsPage() : super();

  @override
  GoodsPageView createState() => GoodsPageView();
}

class GoodsPageView extends ViewState<GoodsPage, GoodsController> {
  SearchBar searchBar;

  GoodsPageView() : super(GoodsController(DataGroupRepository())) {
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
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(title: new Text('Sản phẩm'), actions: [
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
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: controller.openHelpPage,
            child: Icon(
              Icons.help,
              size: 26,
            ),
          ),
        );
      })
    ]);
  }

/*  @override
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
        icon: Icons.add,
        activeIcon: Icons.close,
        buttonSize: 56.0,
        visible: true,
        closeManually: false,
        renderOverlay: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.folder,
                color: Colors.grey,
              ),
              backgroundColor: Colors.white,
              label: 'Nhóm',
              onTap: () => _onAddGroup()),
          SpeedDialChild(
              child: Icon(Icons.image, color: Colors.grey),
              backgroundColor: Colors.white,
              label: 'Sản phẩm',
              onTap: () => _onAddGood())
        ],
      ),
    );
  }*/

  /*void onSelectedGroupTapped(int index) {
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
        Pages.save_good,
        arguments: arguments);
    if (result) {
      screenUpdated();
    }
  }*/

  Widget getBody() {
    //List<Widget> children = [storeView, groupView, stackView];
    //return ListView(children: children);
    //return Column(children: [storeView, groupView],);
    //return SizedBox.expand(child: Column(mainAxisSize: MainAxisSize.max,children: [storeView, groupView],),);
    return SizedBox.expand(child: Container(color: Colors.green,child: Column(mainAxisSize: MainAxisSize.max,children: [storeView, groupView, stackView])));
  }

  Widget get storeView => Container(
      color: UIConstants.primaryDarkColor,
      height: 40,
      width: double.infinity,
      alignment: Alignment.center,
      child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: Text('main store', style: TextStyle(color: Colors.white))));

  Widget get groupView =>
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Visibility(
          visible: true,
          child: Container(
            height: 40,
            color: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.selectedGroups.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(children: [
                    GestureDetector(
                        child: Icon(Icons.home, color: Colors.white),
                        onTap: () => controller.onSelectedGroupTapped(-1)),
                    GestureDetector(
                        child: Row(children: [
                          Icon(Icons.navigate_next, color: Colors.white),
                          Text(controller.selectedGroups[index].name,
                              style: TextStyle(color: Colors.white))
                        ]),
                        onTap: () => controller.onSelectedGroupTapped(0))
                  ]);
                } else {
                  return GestureDetector(
                      child: Row(children: [
                        Icon(Icons.navigate_next, color: Colors.white),
                        Text(controller.selectedGroups[index].name,
                            style: TextStyle(color: Colors.white))
                      ]),
                      onTap: () => controller.onSelectedGroupTapped(index));
                }
              },
            ),
          ),
        );
      });

  Widget get emptyView => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            Icon(
              UIConstants.goodsIconData,
              size: 60,
            ),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Khong co SP nao ca', textAlign: TextAlign.center))
          ],

      );

  Widget get groupListView {
    return  ListView.separated(
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                leading: Icon(Icons.folder),
                title: Text("a"),
                //onTap: () => controller.onGroupTapped(controller.groups[index]),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: 10);
  }

  Widget get stackView {
    //return CoemptyView;
    //return SizedBox.expand(child: emptyView);
      return Stack(fit: StackFit.expand,children: [
      //emptyView,
      Visibility(
        child: emptyView,
        visible: true,
      ),
     /* Visibility(
        child: groupListView,
        visible: true,
      ),*/
    ]);
    // return Expanded(child: Text("abc"));
  }

  @override
  Widget get view => Scaffold(
      key: globalKey,
      appBar: searchBar.build(context),
      body: ControlledWidgetBuilder<GoodsController>(
          builder: (context, controller) {
        return ModalProgressHUD(
            child: getBody(),
            inAsyncCall: controller.isLoading, //controller.isLoading,
            opacity: 0);
      }),
      floatingActionButton: ControlledWidgetBuilder<GoodsController>(
          builder: (context, controller) {
        return SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          buttonSize: 56.0,
          visible: true,
          closeManually: false,
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.folder,
                  color: Colors.grey,
                ),
                backgroundColor: Colors.white,
                label: 'Nhóm',
                onTap: controller.onAddGroup),
            SpeedDialChild(
                child: Icon(Icons.image, color: Colors.grey),
                backgroundColor: Colors.white,
                label: 'Sản phẩm',
                onTap: () => controller.onAddGood)
          ],
        );
      }));
}
