import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:good_manager/app/pages/base/base_page.dart';
import 'package:good_manager/app/pages/goods/bloc/goods_data.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/search_goods_type.dart';
import 'package:good_manager/domain/entities/transaction.dart';

import '../../widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';
import 'bloc/goods_cubit2.dart';
import 'good_item_row.dart';
import 'group_item_row.dart';

class GoodsPage extends StatefulWidget {
  final bool isSelection;
  final DocumentType? documentType;
  final List<DocumentTransaction>? transactions;

  GoodsPage({
      required this.isSelection,
      this.documentType,
      this.transactions});

  @override
  GoodsPageState createState() => GoodsPageState();
}

class GoodsPageState extends BasePageState<GoodsPage, GoodsCubit, GoodsData> {
  @override
  void initState() {
    cubit.initState();
    super.initState();
  }
  Widget _buildBody(BuildContext context, GoodsData data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    List<Widget> children = [
      //StoreView(),
      SelectedStoreView(),
      _buildSelectedGroupView(data),
      _buildSearchBar(context, data),
      Expanded(
            child: Stack(children: [
          Visibility(
            child: emptyView,
            visible: (data.goods.isEmpty && data.groups.isEmpty),
          ),
          Visibility(
            child: _buildListView(data),
            visible: !(data.goods.isEmpty && data.groups.isEmpty),
          )
        ]))
    ];
    return Column(children: children);
  }

  Widget _buildSelectedGroupView(GoodsData data) =>
      Visibility(
          visible: data.selectedGroups.isNotEmpty,
          child: Container(
            height: 40,
            color: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.selectedGroups.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(children: [
                    GestureDetector(
                        child: Icon(Icons.home, color: Colors.white),
                        onTap: () => cubit.onSelectedGroupTapped(-1)),
                    GestureDetector(
                        child: Row(children: [
                          Icon(Icons.navigate_next, color: Colors.white),
                          Text(data.selectedGroups[index].name,
                              style: TextStyle(color: Colors.white))
                        ]),
                        onTap: () => cubit.onSelectedGroupTapped(0))
                  ]);
                } else {
                  return GestureDetector(
                      child: Row(children: [
                        Icon(Icons.navigate_next, color: Colors.white),
                        Text(data.selectedGroups[index].name,
                            style: TextStyle(color: Colors.white))
                      ]),
                      onTap: () => cubit.onSelectedGroupTapped(index));
                }
              },
            ),
          ),
        );

  Widget get emptyView => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(
                UIConstants.goodIconPath,
              )),
          Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(AppLocalizations.of(context)!.empty_goods,
                  textAlign: TextAlign.center))
        ],
      );

  Widget _buildListView(GoodsData data) {
      return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            if (index < data.groups.length) {
              var group = data.groups[index];
              return GroupItemRow(
                  group,
                  (item) => cubit.onGroupTapped(group),
                  (item) => cubit.onGroupLongPressed(group));
            } else {
              var good = data.goods[index - data.groups.length];
              return GoodItemRow(
                  good,
                  good.quantity,
                  (item) => cubit.onGoodTapped(good),
                  (item) => cubit.onGoodLongPressed(good),
                  data.isSelection,
                  data.documentType);
            }
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: data.groups.length + data.goods.length);
  }

  @override
  Widget buildPage(BuildContext context, GoodsData data){
        return WillPopScope(
            onWillPop: () async {
              return true;
            },
            //onWillPop: (){cubit.onBackPressed},
            child: Scaffold(
                //key: globalKey,
                drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 1),
                appBar: new AppBar(
                    title: new Text(AppLocalizations.of(context)!.goods_title),
                    actions: [_buildSearchMenu(data), _buildSortMenu(data), helpMenu]),
                body: _buildBody(context,data),
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
                          child: IconButton(icon: Image.asset(UIConstants.folderIconPath, width: 24), onPressed: () {  },),
                          backgroundColor: Colors.white,
                          label: AppLocalizations.of(context)!.folder,
                          onTap: cubit.onAddGroup),
                      SpeedDialChild(
                          child: IconButton(icon: Image.asset(UIConstants.goodIconPath, width: 24,), onPressed: () {  },),
                          backgroundColor: Colors.white,
                          label: AppLocalizations.of(context)!.good,
                          onTap: cubit.onAddGood)
                    ],
                  )
                ));
  }

  Widget _buildSearchMenu(GoodsData data){
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: Icon(
          UIConstants.searchMenuIconData,
          size: 26,
          color: data.showSearchBar
              ? UIConstants.highlightMenuColor
              : UIConstants.normalMenuColor,
        ),
        onTap: cubit.toggleSearchBar,
      ),
    );
  }
  Widget _buildSortMenu(GoodsData data){
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: Icon(
          UIConstants.sortMenuIconData,
          size: 26,
          color: data.hasSortOptions
              ? UIConstants.highlightMenuColor
              : UIConstants.normalMenuColor,
        ),
        onTap: cubit.onShowSortDialog,
      ),
    );
  }
  Widget get helpMenu =>
       Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: cubit.openHelpPage,
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
          ),
        );


  Widget _buildSearchBar(BuildContext context,GoodsData data){
    return Visibility(child: Row(children: [
      Expanded(
          child: Card(
            child: ListTile(
              title: TextField(
                decoration: InputDecoration(
                    hintText: cubit.getSearchTextHint(context),
                    border: InputBorder.none),
                onChanged: cubit.onSearchTextChanged,
                //controller: controller.searchTextController,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    child: IconButton(
                      icon: Icon(UIConstants.cancelIconData),
                      onPressed: cubit.resetSearchText,
                    ),
                    visible: data.searchText.isNotEmpty,
                  ),
                  IconButton(
                    icon: Image.asset(
                      UIConstants.searchBarcodeIconPath,
                      width: 24,
                    ),
                    onPressed: cubit.onSearchBarCode,
                  )
                ],
              ),
            ),
          )),
      PopupMenuButton<SearchGoodsType>(
        itemBuilder: (BuildContext a) => <PopupMenuEntry<SearchGoodsType>>[
          PopupMenuItem<SearchGoodsType>(
              value: SearchGoodsType.byName,
              child: Text(
                  AppLocalizations.of(context)!.search_goods_type_by_name)),
          PopupMenuItem<SearchGoodsType>(
              value: SearchGoodsType.byDescription,
              child: Text(AppLocalizations.of(context)!
                  .search_goods_type_by_description)),
          PopupMenuItem<SearchGoodsType>(
              value: SearchGoodsType.byBarcode,
              child: Text(AppLocalizations.of(context)!
                  .search_goods_type_by_barcode)),
          PopupMenuItem<SearchGoodsType>(
              value: SearchGoodsType.everywhere,
              child: Text(AppLocalizations.of(context)!
                  .search_goods_type_everywhere)),
        ],
        onSelected: cubit.setSearchGoodsType,
      )
    ]), visible: data.showSearchBar);
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
