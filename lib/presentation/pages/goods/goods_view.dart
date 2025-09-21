import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/component/filter_good_widget.dart';
import 'package:good_manager/presentation/style_size.dart';
import 'package:good_manager/util/string_utils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/currency_formatter.dart';
import '../../blocs/add_quantity_and_price/add_quantity_and_price_dialog.dart';
import '../../dialog/dialog.dart';
import '../../widget/widget.dart';
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
      SizedBox(height: 1),
      _buildSelectedGroupView(state),
      Visibility(
        visible: state.showSearchBar,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
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
        child: Stack(
          children: [
            Visibility(
              child: emptyView,
              visible: (state.goods.isEmpty && state.groups.isEmpty),
            ),
            Visibility(
              child: _buildListView(state),
              visible: !(state.goods.isEmpty && state.groups.isEmpty),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: _buildSummaryInfoWidget(state),
      ),
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
              "${context.tr("quantity")}:  ${StringUtils.getQuantityText(state.quantityTotal)}",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            SizedBox(width: 16),
            VerticalDivider(
              width: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(width: 16),
            Text(
              "${context.tr("total")}: ${CurrencyFormatter.format(context,state.purchasePriceTotal)}/${CurrencyFormatter.format(context,state.salePriceTotal)}",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedGroupView(GoodsState state) => Visibility(
        visible: state.selectedGroups.isNotEmpty && state.textSearch.isEmpty,
        child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          color: Theme.of(context).colorScheme.primary,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.selectedGroups.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  if (index == 0)
                    GestureDetector(
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () =>
                          context.read<GoodsCubit>().onSelectedGroupTapped(-1),
                    ),
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                          size: 30,
                        ),
                        Text(
                          state.selectedGroups[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: TextSize.medium,
                          ),
                        ),
                      ],
                    ),
                    onTap: () =>
                        context.read<GoodsCubit>().onSelectedGroupTapped(index),
                  ),
                ],
              );
            },
          ),
        ),
      );

  Widget get emptyView => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            UIConstants.goodIconData,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 16),
          Text(
            context.tr("no_goods"),
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget _buildListView(GoodsState state) {
    return ListView.separated(
      separatorBuilder: (context, index) => buildDivider(indent: 80),
      itemBuilder: (BuildContext context, index) {
        if (index < state.groups.length) {
          var group = state.groups[index];
          return GroupItemRow(
            group,
            (item) => onPressedGroup(group),
            (item) => onLongPressedGroup(group),
          );
        } else {
          var good = state.goods[index - state.groups.length];
          return GoodItemRow(
            item: good,
            quantity: good.quantity,
            showBarcode: state.settings.showBarcode,
            showDescription: state.settings.showDescription,
            showMinQuantity: state.showMinQuantity,
            minQuantityColor: state.minQuantityColor ?? Colors.black,
            onGoodTapped: (item) => onPressedGood(good),
            onGoodLongPressed: (item) => onLongPressedGood(good),
            isSelection: state.isSelection,
          );
        }
      },
      itemCount: state.groups.length + state.goods.length,
    );
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
      icon: Icon(
        Icons.search,
        color: state.showSearchBar
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).iconTheme.color,
      ),
    );
  }

  // Widget _buildSortMenu(GoodsState state) {
  //   return IconButton(
  //       onPressed: () {
  //         context.read<GoodsCubit>().onSortMenuClicked();
  //       },
  //       icon: Icon(Icons.sort,
  //           color: context.read<GoodsCubit>().hasSortOptions()
  //               ? Theme.of(context).colorScheme.primary
  //               : Theme.of(context).iconTheme.color));
  // }
  Widget _buildFilterMenu(GoodsState state) {
    bool showWarning = (state.settings.sortByName != SortByText.no_sort ||
        state.settings.sortByBarcode != SortByNumber.no_sort ||
        state.settings.sortByQuantity != SortByNumber.no_sort);
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            showFilterBottomSheet(state);
          },
          icon: Icon(Icons.filter_alt),
        ),
        if (showWarning)
          Positioned(
            right: 4,
            top: 4,
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 16,
            ),
          ),
      ],
    );
  }

  void showFilterBottomSheet(GoodsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext mContext) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (mContext, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              child: FilterGoodWidget(
                onResetAllPressed: () {
                  context.read<GoodsCubit>().resetAllFilter();
                  Navigator.of(context).pop();
                },
                onApplyPressed: (setting) {
                  context.read<GoodsCubit>().applyFilter(setting);
                  Navigator.of(context).pop();
                },
                setting: state.settings,
              ),
            );
          },
        );
      },
    );
  }

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
      barrierDismissible: true,
    );
    if (result != null) {
      double quantity = result["quantity"] ?? 0.0;
      double price = result["price"] ?? 0.0;
      context.read<GoodsCubit>().addTransaction(good.id!, quantity, price);
    }
  }

  void onLongPressedGood(Good item) {
    var items = [
      context.tr("action_move_to_group"),
      context.tr("item_history_title"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] ==
            context.tr("action_move_to_group")) {
          openSelectGroupForGood(item);
        } else if (items[index] ==
            context.tr("item_history_title")) {
          Navigator.of(context).pushNamed(
            Pages.good_history,
            arguments: {'goodId': item.id},
          );
        } else if (items[index] ==
            context.tr("delete")) {
          showDeleteGoodConfirmPopup(item);
        }
      },
    );
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
    final result = await Navigator.of(context).pushNamed(
      Pages.select_group,
      arguments: {"groupId": item.groupId, "id": item.id},
    );
    if (result != null) {
      Map<dynamic, dynamic> map = result as Map<dynamic, dynamic>;
      int? selectedGroupId = map["groupId"];
      if (item.groupId != selectedGroupId) {
        context.read<GoodsCubit>().moveGroupToGroup(item, selectedGroupId);
      }
    }
  }

  void showDeleteGoodConfirmPopup(Good item) async {
    showCustomAlertDialog(
      context,
      message: sprintf(
        context.tr("message_confirm_delete"),
        [item.name],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        await context.read<GoodsCubit>().deleteGood(item.id!);
      },
    );
  }

  void onPressedGroup(Group item) {
    context.read<GoodsCubit>().onGroupTapped(item);
  }

  void onLongPressedGroup(Group item) {
    var items = [
      context.tr("action_move_to_group"),
      context.tr("action_edit_group"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] ==
            context.tr("action_move_to_group")) {
          openSelectGroupForGroup(item);
        } else if (items[index] ==
            context.tr("action_edit_group")) {
          final result = await Navigator.of(context)
              .pushNamed(Pages.save_group, arguments: {"item": item});
          if (result != null) {
            context.read<GoodsCubit>().loadData();
            //context.read<GoodsCubit>().loadItems();
          }
        } else if (items[index] ==
            context.tr("delete")) {
          context.read<GoodsCubit>().deleteGroup(item.id!);
        }
      },
    );
  }

  // void showSaveGroupBottomSheet(Group item){
  //   showModalBottomSheet(context: context, isScrollControlled: true ,builder: (BuildContext mContext){
  //     return SafeArea(child: BlocProvider(create: (_) => getIt<SaveGroupCubit>(),child: SaveGroupPage(item: item)));
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoodsCubit, GoodsState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        // if (state.state is OpenSortDialogListState) {
        //   GoodsSetting? settings = await showDialog(
        //     context: context,
        //     builder: (_) => SortGoodsDialog(state.settings),
        //     barrierDismissible: true,
        //   );
        //   if (settings != null) {
        //     context.read<GoodsCubit>().setSettings(settings);
        //   }
        // } else

          if (state.state is OpenHelpPageState) {
          Navigator.of(context).pushNamed(
            Pages.help,
            arguments: {
              "title": context.tr("goods"),
              "content": MDProviderFactory.get().getHelpText(HelpType.GOODS),
            },
          );
        } else if (state.state is OpenSaveGoodPageState) {
          final currentState = state.state as OpenSaveGoodPageState;
          await Navigator.of(context).pushNamed(
            Pages.save_good,
            arguments: {"item": currentState.item},
          );
          context.read<GoodsCubit>().loadData();
        } else if (state.state is AddGroupState) {
          final currentState = state.state as AddGroupState;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_group,
            arguments: {"item": currentState.item},
          );
          if (result != null) {
            context.read<GoodsCubit>().loadData();
          }
          //showSaveGroupBottomSheet(currentState.item);
        } else if (state.state is InsertTransactionSuccessState) {
          final currentState = state.state as InsertTransactionSuccessState;
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarWhenSuccessWithText(
              context.tr("insert_transaction_success"),
            ),
          );
          context
              .read<GoodsCubit>()
              .updateQuantity(currentState.goodId, currentState.quantity);
        } else if (state.state is InsertTransactionFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarWhenFailureWithText(
              context.tr("insert_transaction_fail"),
            ),
          );
        } else if (state.state is OpenListSettingsDialogState) {
          GoodsSetting? settings = await showDialog(
            context: context,
            builder: (_) => ListSettingsDialog(state.settings),
            barrierDismissible: true,
          );
          if (settings != null) {
            context.read<GoodsCubit>().setSettings(settings);
          }
        }
      },
      builder: (context, state) => Scaffold(
        appBar: new AppBar(
          title: new Text(
            widget.isSelection
                ? context.tr("select_good")
                : context.tr("goods"),
          ),
          actions: [
            _buildSearchMenu(state),
            _buildFilterMenu(state),
            //_buildSortMenu(state),
            PopupMenuButton<OverflowMenuItem>(
              onSelected: (OverflowMenuItem item) {
                if (item == OverflowMenuItem.listSettings) {
                  context.read<GoodsCubit>().onListSettingsMenuClicked();
                } else if (item == OverflowMenuItem.help) {
                  context.read<GoodsCubit>().onHelpMenuClicked();
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<OverflowMenuItem>>[
                PopupMenuItem<OverflowMenuItem>(
                  value: OverflowMenuItem.listSettings,
                  child: Text(
                    context.tr("list_settings"),
                  ),
                ),
                PopupMenuItem<OverflowMenuItem>(
                  value: OverflowMenuItem.help,
                  child: Text(
                    context.tr("action_help"),
                  ),
                ),
              ],
            ),
          ],
        ),
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
              icon: Icon(
                UIConstants.goodIconData,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(context.tr("action_add_good")),
              heroTag: 'add_good_tab',
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
              icon: Icon(
                UIConstants.groupIconData,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(context.tr("action_add_group")),
              onPressed: () {
                final state = _key.currentState;
                if (state != null) {
                  debugPrint('isOpen:${state.isOpen}');
                  state.toggle();
                }
                context.read<GoodsCubit>().onAddGroup();
              },
            ),
          ],
        ),
      ),
    );
  }
}
