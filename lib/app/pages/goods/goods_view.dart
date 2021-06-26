import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_document_transaction_repository.dart';
import 'package:good_manager/data/repositories/data_good_repository.dart';
import 'package:good_manager/data/repositories/data_group_repository.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/search_goods_type.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'good_item_row.dart';
import 'goods_controller.dart';
import 'group_item_row.dart';

class GoodsPage extends View {
  final bool isSelection;
  final DocumentType documentType;

  GoodsPage({Key key, @required this.isSelection, this.documentType});

  @override
  GoodsPageView createState() =>
      GoodsPageView(this.isSelection, this.documentType);
}

class GoodsPageView extends ViewState<GoodsPage, GoodsController> {
  GoodsPageView(isSelection, documentType)
      : super(GoodsController(DataGroupRepository(), DataGoodRepository(),
            DataDocumentTransactionRepository(), isSelection, documentType));

  Widget getBody() {
    List<Widget> children = [
      storeView,
      selectedGroupView,
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Visibility(child: searchBar, visible: controller.showSearchBar);
      }),
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Expanded(
            child: Stack(children: [
          Visibility(
            child: emptyView,
            visible: controller.isEmpty(),
          ),
          Visibility(
            child: listView,
            visible: !controller.isEmpty(),
          )
        ]));
      })
    ];
    return Column(children: children);
  }

  Widget get storeView => Container(
      color: UIConstants.primaryDarkColor,
      width: double.infinity,
      alignment: Alignment.center,
      child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: Text('main store', style: TextStyle(color: Colors.white))));

  Widget get selectedGroupView =>
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Visibility(
          visible: controller.selectedGroups.isNotEmpty,
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
              child: Text(AppLocalizations.of(context).empty_goods,
                  textAlign: TextAlign.center))
        ],
      );

  Widget get listView {
    return ControlledWidgetBuilder<GoodsController>(
        builder: (context, controller) {
      return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            if (index < controller.groups.length) {
              var group = controller.groups[index];
              return GroupItemRow(
                  group,
                  (item) => controller.onGroupTapped(group),
                  (item) => controller.onGroupLongPressed(group));
            } else {
              var good = controller.goods[index - controller.groups.length];
              return GoodItemRow(
                  good,
                  good.quantity,
                  (item) => controller.onGoodTapped(good),
                  (item) => controller.onGoodLongPressed(good),
                  controller.isSelection,
                  controller.documentType);
            }
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: controller.groups.length + controller.goods.length);
    });
  }

  Future<bool> _onBackPressed() async {
    //Navigator.of(context).pop(controller.transactions);
  }

  @override
  Widget get view => WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: globalKey,
          appBar: new AppBar(
              title: new Text(AppLocalizations.of(context).title_goods),
              actions: [searchMenu, sortMenu, helpMenu]),
          body: ControlledWidgetBuilder<GoodsController>(
              builder: (context, controller) {
            return ModalProgressHUD(
                child: getBody(),
                inAsyncCall: controller.isLoading,
                //controller.isLoading,
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
                    onTap: controller.onAddGood)
              ],
            );
          })));

  Widget get searchMenu =>
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: controller.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: controller.toggleSearchBar,
          ),
        );
      });

  Widget get sortMenu =>
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: controller.hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: controller.onShowSortDialog,
          ),
        );
      });

  Widget get helpMenu => Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          child: Icon(
            UIConstants.helpMenuIconData,
            size: 26,
          ),
        ),
      );

  Widget get searchBar =>
      ControlledWidgetBuilder<GoodsController>(builder: (context, controller) {
        return Row(children: [
          Expanded(
              child: Card(
            child: ListTile(
              title: TextField(
                decoration: InputDecoration(
                    hintText: controller.getSearchTextHint(),
                    border: InputBorder.none),
                onChanged: controller.onSearchChanged,
                controller: controller.searchTextController,
              ),
              trailing: Visibility(
                child: IconButton(
                  icon: Icon(UIConstants.cancelIconData),
                  onPressed: controller.resetSearchText,
                ),
                visible: controller.textSearch.isNotEmpty,
              ),
            ),
          )),
          PopupMenuButton<SearchGoodsType>(
            itemBuilder: (BuildContext a) => <PopupMenuEntry<SearchGoodsType>>[
              PopupMenuItem<SearchGoodsType>(
                  value: SearchGoodsType.byName,
                  child:
                      Text(AppLocalizations.of(context).search_type_by_name)),
              PopupMenuItem<SearchGoodsType>(
                  value: SearchGoodsType.byDescription,
                  child: Text(
                      AppLocalizations.of(context).search_type_by_description)),
              PopupMenuItem<SearchGoodsType>(
                  value: SearchGoodsType.byBarcode,
                  child: Text(
                      AppLocalizations.of(context).search_type_by_barcode)),
              PopupMenuItem<SearchGoodsType>(
                  value: SearchGoodsType.everywhere,
                  child: Text(
                      AppLocalizations.of(context).search_type_everywhere)),
            ],
            onSelected: controller.setSearchGoodsType,
          )
        ]);
      });
}
