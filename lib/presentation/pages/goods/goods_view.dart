import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/goods_setting.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/entities/search_goods_type.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit2.dart';
import 'package:good_manager/presentation/pages/goods/widgets/sort_goods_dialog.dart';
import 'package:sprintf/sprintf.dart';

import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';
import '../help_content.dart';
import '../pages.dart';
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

class GoodsPageState extends State<GoodsPage> {
  final TextEditingController searchTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<GoodsCubit>().initState(widget.isSelection, widget.documentType);
  }
  Widget _buildBody(BuildContext context, GoodsState state) {
    if (state.state is LoadingState) {
      return _buildLoading();
    }
    List<Widget> children = [
      //StoreView(),
      SelectedStoreView(),
      _buildSelectedGroupView(state),
      _buildSearchBar(context, state),
      Expanded(
            child: Stack(children: [
          Visibility(
            child: emptyView,
            visible: (state.goods.isEmpty && state.groups.isEmpty),
          ),
          Visibility(
            child: _buildListView(state),
            visible: !(state.goods.isEmpty && state.groups.isEmpty),
          )
        ]))
    ];
    return Column(children: children);
  }

  Widget _buildSelectedGroupView(GoodsState state) =>
      Visibility(
          visible: state.selectedGroups.isNotEmpty,
          child: Container(
            height: 40,
            padding: EdgeInsets.only(left: 16.0),
            color: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.selectedGroups.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(children: [
                    GestureDetector(
                        child: Icon(Icons.home, color: Colors.white),
                        onTap: () => context.read<GoodsCubit>().onSelectedGroupTapped(-1)),
                    GestureDetector(
                        child: Row(children: [
                          Icon(Icons.navigate_next, color: Colors.white),
                          Text(state.selectedGroups[index].name,
                              style: TextStyle(color: Colors.white))
                        ]),
                        onTap: () => context.read<GoodsCubit>().onSelectedGroupTapped(0))
                  ]);
                } else {
                  return GestureDetector(
                      child: Row(children: [
                        Icon(Icons.navigate_next, color: Colors.white),
                        Text(state.selectedGroups[index].name,
                            style: TextStyle(color: Colors.white))
                      ]),
                      onTap: () => context.read<GoodsCubit>().onSelectedGroupTapped(index));
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

  Widget _buildListView(GoodsState state) {
      return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            if (index < state.groups.length) {
              var group = state.groups[index];
              return GroupItemRow(
                  group,
                  (item) => onPressedGroup(group),
                  (item) => onLongPressedGroup(group));
            } else {
              var good = state.goods[index - state.groups.length];
              return GoodItemRow(
                  good,
                  good.quantity,
                  (item) => onPressedGood(good),
                  (item) => onLongPressedGood(good),
                  state.isSelection,
                  state.documentType);
            }
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: state.groups.length + state.goods.length);
  }

  Widget _buildSearchMenu(GoodsState state){
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: Icon(
          UIConstants.searchMenuIconData,
          size: 26,
          color: state.showSearchBar
              ? UIConstants.highlightMenuColor
              : UIConstants.normalMenuColor,
        ),
        onTap: context.read<GoodsCubit>().onShowSearchBarMenuClicked,
      ),
    );
  }
  Widget _buildSortMenu(GoodsState state){
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: Icon(
          UIConstants.sortMenuIconData,
          size: 26,
          color: context.read<GoodsCubit>().hasSortOptions()
              ? UIConstants.highlightMenuColor
              : UIConstants.normalMenuColor,
        ),
        onTap: context.read<GoodsCubit>().onSortMenuClicked,
      ),
    );
  }
  Widget get helpMenu =>
       Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: context.read<GoodsCubit>().openHelpPage,
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
          ),
        );


  Widget _buildSearchBar(BuildContext context,GoodsState state){
    return Visibility(child: Row(children: [
      Expanded(
          child: Card(
            child: ListTile(
              title: TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                    hintText: context.read<GoodsCubit>().getSearchTextHint(context),
                    border: InputBorder.none),
                onChanged: context.read<GoodsCubit>().onSearchTextChanged,
                //controller: controller.searchTextController,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    child: IconButton(
                      icon: Icon(UIConstants.cancelIconData),
                      onPressed: (){
                        searchTextController.text = "";
                        context.read<GoodsCubit>().resetSearchText();
                      },
                    ),
                    visible: state.textSearch.isNotEmpty,
                  ),
                  IconButton(
                    icon: Image.asset(
                      UIConstants.searchBarcodeIconPath,
                      width: 24,
                    ),
                    onPressed: context.read<GoodsCubit>().onSearchBarCode,
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
        onSelected: context.read<GoodsCubit>().setSearchGoodsType,
      )
    ]), visible: state.showSearchBar);
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  void onPressedGood(Good item) async{
    final result = await Navigator.of(context)
        .pushNamed(Pages.save_good, arguments: {"item": item, "enableAddTransactions": true});
    if (result != null) {
      context.read<GoodsCubit>().loadItems();
    }

    /*if (this._isSelection) {
      showAddQuantityDialog(good);
    } else {
      final result = await Navigator.of(getContext())
          .pushNamed(Pages.save_good, arguments: {"item": good, "enableAddTransactions": true});
      if (result != null) {
        loadData();
      }
    }*/
  }
  void onLongPressedGood(Good item){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  //openSelectGroupForGood(good);
                },
                child: Text(
                    AppLocalizations.of(context)!.action_move_to_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteGoodConfirmPopup(item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }
  void showDeleteGoodConfirmPopup(Good item) async{
    bool result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(context)!.message_confirm_delete_good,
                [item.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<GoodsCubit>().deleteGood(item.id);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
    if (result){
      int a = 2;
    }else{
      int a = 1;
    }
  }

  void onPressedGroup(Group item){
    context.read<GoodsCubit>().onGroupTapped(item);
  }
  void onLongPressedGroup(Group item){
    showDialog(
        context: context,
        builder: (BuildContext a) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  //openSelectGroupForGroup(group);
                },
                child: Text(
                    AppLocalizations.of(context)!.action_move_to_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () async{
                  Navigator.pop(context);
                  final result = await Navigator.of(context)
                      .pushNamed(Pages.save_group, arguments: {"item": item});
                  if (result != null) {
                    context.read<GoodsCubit>().loadItems();
                  }
                  //onEditGroup(group);
                },
                child:
                Text(AppLocalizations.of(context)!.action_edit_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showInfoToast("under development");
                },
                child:
                Text(AppLocalizations.of(context)!.action_delete_group),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoodsCubit, GoodsState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async{
          if (state.state is OpenSortDialogListState){
            GoodsSetting settings = await showDialog(
                context: context,
                builder: (_) => SortGoodsDialog(state.settings),
                barrierDismissible: true);
            context.read<GoodsCubit>().setSettings(settings);
          }
          else if (state.state is OpenHelpPageState){
            ///TODO
            //String code = await appDataManager.sharedPrefsHelper.getLanguageCode();
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.goods_title,
              "content": HelpUtils.getMarkdownData("vi", HelpType.GOODS)
            });
          }else if (state.state is AddGoodState){
            final currentState = state.state as AddGoodState;
            final result = await Navigator.of(context)
                .pushNamed(Pages.save_good, arguments: {"item": currentState.item, "enableAddTransactions": true});
            ///TODO
            /*if (result != null) {
              if (_isSelection) {
                showAddQuantityDialog(result);
              } else {
                loadData();
              }
            }*/
            if (result != null){
              context.read<GoodsCubit>().loadItems();
            }
          }else if (state.state is AddGroupState){
            final currentState = state.state as AddGroupState;
            final result = await Navigator.of(context).pushNamed(Pages.save_group, arguments: {"item" : currentState.item});
            if (result != null){
              context.read<GoodsCubit>().loadItems();
            }
          }
        },
        builder: (context, state) =>  Scaffold(
            drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 1),
            appBar: new AppBar(
                title: new Text(AppLocalizations.of(context)!.goods_title),
                actions: [_buildSearchMenu(state), _buildSortMenu(state), helpMenu]),
            body: _buildBody(context,state),
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
                    child: IconButton(icon: Image.asset(UIConstants.folderIconPath, width: 24), onPressed: context.read<GoodsCubit>().onAddGroup,),
                    backgroundColor: Colors.white,
                    label: AppLocalizations.of(context)!.folder
                ),
                SpeedDialChild(
                    child: IconButton(icon: Image.asset(UIConstants.goodIconPath, width: 24), onPressed: context.read<GoodsCubit>().onAddGood,),
                    backgroundColor: Colors.white,
                    label: AppLocalizations.of(context)!.good)
              ],
            )
        ));
  }
}
