import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/goods_setting.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/widgets/list_settings_dialog.dart';
import 'package:good_manager/presentation/pages/goods/widgets/sort_goods_dialog.dart';
import 'package:good_manager/presentation/style_size.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:sprintf/sprintf.dart';

import '../../widgets/add_quantity_and_price/add_quantity_and_price_dialog.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/snackbar_widgets.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'good_item_row.dart';
import 'group_item_row.dart';

class GoodsPage extends StatefulWidget {
  final bool isSelection;
  final Document? document;

  GoodsPage({required this.isSelection, this.document}) : super();

  @override
  GoodsPageState createState() => GoodsPageState();
}

enum OverflowMenuItem { listSettings, help }

class GoodsPageState extends State<GoodsPage> {
  final FocusNode searchTextFocusNode = FocusNode();
  final _key = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();
    context.read<GoodsCubit>().initState(widget.isSelection, widget.document);
  }


  Widget _buildBody(BuildContext context, GoodsState state) {
    if (state.state is LoadingState) {
      return _buildLoading();
    }
    List<Widget> children = [
      SelectedStoreView(),
      _buildSelectedGroupView(state),
      Visibility(
        visible: state.showSearchBar,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top : 16),
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              context.read<GoodsCubit>().onSearchTextChanged(newValue);
            },
            focusNode: searchTextFocusNode,
            showCamera: true,
          ),
        ),
      ),
      //_buildSearchBar(context, state),
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
      ])),
      Align(
        alignment: Alignment.bottomLeft,
        child: _buildSummaryInfoWidget(state),
      )
    ];
    return Column(children: children);
  }

  Widget _buildSummaryInfoWidget(GoodsState state) {
    return Container(
        height: 32,
        color: Theme.of(context).colorScheme.primary,
        child: IntrinsicHeight(
            child: Row(
          children: [
            SizedBox(width: 16),
            Text(
                "${AppLocalizations.of(context)!.field_quantity_short_form}:  ${Config.currencyFormat.format(state.quantityTotal)}",
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            SizedBox(width: 16),
            VerticalDivider(width: 2, color: Theme.of(context).colorScheme.onPrimary),
            SizedBox(width: 16),
            Text(
                "${AppLocalizations.of(context)!.field_total_short_form}: ${Config.currencyFormat.format(state.purchasePriceTotal)}/${Config.currencyFormat.format(state.salePriceTotal)}",
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
          ],
        )));
  }

  Widget _buildSelectedGroupView(GoodsState state) => Visibility(
        visible: state.selectedGroups.isNotEmpty && state.textSearch.isEmpty,
        child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          color: Colors.blue,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.selectedGroups.length,
            itemBuilder: (context, index) {
              return Row(children: [
                if (index == 0)
                  GestureDetector(
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () =>
                          context.read<GoodsCubit>().onSelectedGroupTapped(-1)),
                GestureDetector(
                    child: Row(children: [
                      Icon(Icons.navigate_next, color: Colors.white, size: 30),
                      Text(state.selectedGroups[index].name,
                          style: TextStyle(
                              color: Colors.white, fontSize: TextSize.medium))
                    ]),
                    onTap: () =>
                        context.read<GoodsCubit>().onSelectedGroupTapped(index))
              ]);
            },
          ),
        ),
      );

  Widget get emptyView => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(UIConstants.goodIconData, size: 64, color: Theme.of(context).colorScheme.primary),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.empty_goods, textAlign: TextAlign.center)
        ],
      );

  Widget _buildListView(GoodsState state) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[200],
          indent: 80,     // Adds 40 pixels of left padding
          endIndent: 0,   // Keeps the right edge flush (can adjust if needed)
        ),
        itemBuilder: (BuildContext context, index) {
          if (index < state.groups.length) {
            var group = state.groups[index];
            return GroupItemRow(group, (item) => onPressedGroup(group),
                (item) => onLongPressedGroup(group));
          } else {
            var good = state.goods[index - state.groups.length];
            return GoodItemRow(
                item: good,
                quantity: good.quantity,
                showBarcode: state.settings.showBarcode,
                showDescription: state.settings.showDescription,
                showMinQuantity: state.showMinQuantity,
                minQuantityColor: state.minQuantityColor??Colors.black,
                onGoodTapped: (item) => onPressedGood(good),
                onGoodLongPressed: (item) => onLongPressedGood(good),
                isSelection: state.isSelection);
          }
        },
        itemCount: state.groups.length + state.goods.length);
  }

  Widget _buildSearchMenu(GoodsState state) {
    return IconButton(
        onPressed: () {
          //searchTextController.text = "";
          if (!state.showSearchBar) {
            searchTextFocusNode.requestFocus();
          }
          context.read<GoodsCubit>().onShowSearchBarMenuClicked();
        },
        icon: Icon(Icons.search,
            color: state.showSearchBar
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color));
  }

  Widget _buildSortMenu(GoodsState state) {
    return IconButton(
        onPressed: () {
          context.read<GoodsCubit>().onSortMenuClicked();
        },
        icon: Icon(Icons.sort,
            color: context.read<GoodsCubit>().hasSortOptions()
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color));
  }

  // Widget _buildSearchBar(BuildContext context, GoodsState state) {
  //   return Visibility(
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
  //         child: Container(
  //             decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(8), // Rounded corners
  //           ),
  //           child: ListTile(
  //                   leading: Icon(Icons.search),
  //                   title: TextField(
  //
  //                     controller: searchTextController,
  //                     decoration: InputDecoration(
  //                         hintText: AppLocalizations.of(context)!.hint_search_by,
  //                         border: InputBorder.none
  //                         ),
  //                     onChanged: context.read<GoodsCubit>().onSearchTextChanged,
  //
  //                   ),
  //                   trailing: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Visibility(
  //                         child: IconButton(
  //                           icon: Icon(UIConstants.cancelIconData),
  //                           onPressed: () {
  //                             searchTextController.text = "";
  //                             context.read<GoodsCubit>().onSearchTextChanged("");
  //                           },
  //                         ),
  //                         visible: state.textSearch.isNotEmpty,
  //                       ),
  //                       IconButton(
  //                         //icon: Icon(Icons.barcode_reader),
  //                         icon: Image.asset(
  //                           UIConstants.searchBarcodeIconPath,
  //                           width: 24,
  //                         ),
  //                         onPressed:
  //                             context.read<GoodsCubit>().onSearchBarcodeClicked,
  //                       )
  //                     ],
  //                   ),
  //           ),
  //         ),
  //       ),
  //       visible: state.showSearchBar);
  // }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void onPressedGood(Good item) async {
    if (widget.isSelection) {
      showAddQuantityAndPriceDialog(item, widget.document!.type);
    } else {
      await Navigator.of(context)
          .pushNamed(Pages.save_good, arguments: {"item": item});
      context.read<GoodsCubit>().loadData();
      //context.read<GoodsCubit>().loadItems();
    }
  }

  void showAddQuantityAndPriceDialog(Good good, DocumentType type) async {
    Map<dynamic, dynamic>? result = await showDialog(
        context: context,
        builder: (_) => AddQuantityAndPriceWidget(good, type),
        barrierDismissible: true);
    if (result != null) {
      double quantity = result["quantity"] ?? 0.0;
      double price = result["price"] ?? 0.0;
      context.read<GoodsCubit>().addTransaction(good.id!, quantity, price);
    }
  }

  void onLongPressedGood(Good item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  openSelectGroupForGood(item);
                },
                child: Text(AppLocalizations.of(context)!.action_move_to_group),
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

  void openSelectGroupForGood(Good item) async {
    final result = await Navigator.of(context)
        .pushNamed(Pages.select_group, arguments: {"groupId": item.groupId});
    if (result != null) {
      Map<dynamic, dynamic> map = result as Map<dynamic, dynamic>;
      int? selectedGroupId = map["groupId"];
      if (item.groupId != selectedGroupId) {
        context.read<GoodsCubit>().moveGoodToGroup(item, selectedGroupId);
      }
    }
  }

  void openSelectGroupForGroup(Group item) async {
    final result = await Navigator.of(context).pushNamed(Pages.select_group,
        arguments: {"groupId": item.groupId, "id": item.id});
    if (result != null) {
      Map<dynamic, dynamic> map = result as Map<dynamic, dynamic>;
      int? selectedGroupId = map["groupId"];
      if (item.groupId != selectedGroupId) {
        context.read<GoodsCubit>().moveGroupToGroup(item, selectedGroupId);
      }
    }
  }

  void showDeleteGoodConfirmPopup(Good item) async {
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return AlertDialog(
            title:
                Text(AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(context)!.message_confirm_delete,
                [item.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () async {
                  await context.read<GoodsCubit>().deleteGood(item.id!);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }

  void onPressedGroup(Group item) {
    context.read<GoodsCubit>().onGroupTapped(item);
  }

  void onLongPressedGroup(Group item) {
    showDialog(
        context: context,
        builder: (BuildContext a) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  openSelectGroupForGroup(item);
                },
                child: Text(AppLocalizations.of(context)!.action_move_to_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () async {
                  Navigator.pop(context);
                  final result = await Navigator.of(context)
                      .pushNamed(Pages.save_group, arguments: {"item": item});
                  if (result != null) {
                    context.read<GoodsCubit>().loadData();
                    //context.read<GoodsCubit>().loadItems();
                  }
                },
                child: Text(AppLocalizations.of(context)!.action_edit_group),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<GoodsCubit>().deleteGroup(item.id!);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
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
        listener: (context, state) async {
          if (state.state is OpenSortDialogListState) {
            GoodsSetting? settings = await showDialog(
                context: context,
                builder: (_) => SortGoodsDialog(state.settings),
                barrierDismissible: true);
            if (settings != null) {
              context.read<GoodsCubit>().setSettings(settings);
            }
          } else if (state.state is OpenHelpPageState) {
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.goods_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.GOODS)
            });
          } else if (state.state is OpenSaveGoodPageState) {
            final currentState = state.state as OpenSaveGoodPageState;
            await Navigator.of(context).pushNamed(Pages.save_good,
                arguments: {"item": currentState.item});
            context.read<GoodsCubit>().loadData();
            //context.read<GoodsCubit>().loadItems();
          } else if (state.state is AddGroupState) {
            final currentState = state.state as AddGroupState;
            final result = await Navigator.of(context).pushNamed(
                Pages.save_group,
                arguments: {"item": currentState.item});
            if (result != null) {
              context.read<GoodsCubit>().loadData();
              //context.read<GoodsCubit>().loadItems();
            }
          } else if (state.state is InsertTransactionSuccessState) {
            final currentState = state.state as InsertTransactionSuccessState;
            ScaffoldMessenger.of(context).showSnackBar(
                snackBarWhenSuccessWithText(
                    AppLocalizations.of(context)!.insert_transaction_success));
            context
                .read<GoodsCubit>()
                .updateQuantity(currentState.goodId, currentState.quantity);
          } else if (state.state is InsertTransactionFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
                snackBarWhenFailureWithText(
                    AppLocalizations.of(context)!.insert_transaction_fail));
          }
          else if (state.state is OpenListSettingsDialogState){
            GoodsSetting? settings = await showDialog(
                context: context,
                builder: (_) => ListSettingsDialog(state.settings),
                barrierDismissible: true);
            if (settings != null) {
              context.read<GoodsCubit>().setSettings(settings);
            }
          }
        },
        builder: (context, state) => Scaffold(

            appBar: new AppBar(
                title: new Text(widget.isSelection
                    ? AppLocalizations.of(context)!.goods_select_title
                    : AppLocalizations.of(context)!.goods_title),
                actions: [
                  _buildSearchMenu(state),
                  _buildSortMenu(state),
                  PopupMenuButton<OverflowMenuItem>(
                      onSelected: (OverflowMenuItem item) {
                        if (item == OverflowMenuItem.listSettings){
                          context.read<GoodsCubit>().onListSettingsMenuClicked();
                        }else if (item == OverflowMenuItem.help){
                          context.read<GoodsCubit>().onHelpMenuClicked();
                        }
                      },
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<OverflowMenuItem>>[
                            PopupMenuItem<OverflowMenuItem>(
                              value: OverflowMenuItem.listSettings,
                              child: Text(AppLocalizations.of(context)!.list_settings),
                            ),
                            PopupMenuItem<OverflowMenuItem>(
                              value: OverflowMenuItem.help,
                              child: Text(AppLocalizations.of(context)!.action_help),
                            )
                          ]),
                ]),
            body: _buildBody(context, state),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            key: _key,
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: const Icon(Icons.add),
            ),
            type: ExpandableFabType.up,
            //childrenAnimation: ExpandableFabAnimation.none,
            distance: 70,
            overlayStyle: ExpandableFabOverlayStyle(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            ),
            children: [
              FloatingActionButton.extended(
                icon:  Icon(UIConstants.goodIconData, size: 24, color: Theme.of(context).colorScheme.primary),
                label: Text(AppLocalizations.of(context)!.action_add_good),
                heroTag: null,
                onPressed: () {
                  final state = _key.currentState;
                  if (state != null) {
                    debugPrint('isOpen:${state.isOpen}');
                    state.toggle();
                  }
                  context.read<GoodsCubit>().onAddGood();
                },
              ),
              FloatingActionButton.extended(
                icon: Icon(UIConstants.groupIconData, size: 24, color: Theme.of(context).colorScheme.primary),
                label: Text(AppLocalizations.of(context)!.action_add_group),
                onPressed: (){
                  final state = _key.currentState;
                  if (state != null) {
                    debugPrint('isOpen:${state.isOpen}');
                    state.toggle();
                  }
                  context.read<GoodsCubit>().onAddGroup();
                }
              ),
            ],
          ),
        ));
  }
}
