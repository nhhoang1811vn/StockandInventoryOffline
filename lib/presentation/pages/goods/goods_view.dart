import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/component/excel_column_mapping_sheet.dart';
import 'package:good_manager/presentation/pages/goods/component/list_settings_good_widget.dart';
import 'package:good_manager/presentation/pages/goods/component/sort_good_widget.dart';
import 'package:good_manager/presentation/utils/share_utils.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:good_manager/util/string_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../blocs/add_quantity_and_price/add_quantity_and_price_dialog.dart';
import '../../dialog/dialog.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'good_item_row.dart';
import 'group_item_row.dart';

enum GoodsOverflowMenu { importExcel, exportExcel, listSettings, help }

class GoodsPage extends StatefulWidget {
  final bool isSelection;
  final Document? document;

  GoodsPage({required this.isSelection, this.document}) : super();

  @override
  GoodsPageState createState() => GoodsPageState();
}

class GoodsPageState extends State<GoodsPage> {
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<GoodsCubit>().initState(widget.isSelection, widget.document);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<GoodsCubit, GoodsState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
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
          showListSettingsBottomSheet(state);
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            widget.isSelection
                ? context.tr("select_good")
                : context.tr("inventory"),
            style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800),
          ),
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddMenu(context),
            ),
            const SizedBox(width: 12),
            PopupMenuButton<GoodsOverflowMenu>(
              offset: const Offset(0, 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (item) => _onOverflowMenuSelected(item, state),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<GoodsOverflowMenu>>[
                PopupMenuItem<GoodsOverflowMenu>(
                  value: GoodsOverflowMenu.importExcel,
                  child: Text(context.tr("action_import_from_excel")),
                ),
                PopupMenuItem<GoodsOverflowMenu>(
                  value: GoodsOverflowMenu.exportExcel,
                  child: Text(context.tr("action_export_to_excel")),
                ),
                PopupMenuItem<GoodsOverflowMenu>(
                  value: GoodsOverflowMenu.listSettings,
                  child: Text(context.tr("list_settings")),
                ),
                PopupMenuItem<GoodsOverflowMenu>(
                  value: GoodsOverflowMenu.help,
                  child: Text(context.tr("action_help")),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildSelectedGroupView(state),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildSearchRow(state),
              ),
              Expanded(
                child: state.goods.isEmpty && state.groups.isEmpty
                    ? _buildEmptyView()
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        children: [
                          _buildList(state),
                          const SizedBox(height: 16),
                        ],
                      ),
              ),
              if (!state.isSelection)
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: _buildSummaryInfo(state),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(UIConstants.goodIconData,
                color: theme.colorScheme.primary),
            title: Text(context.tr("action_add_good")),
            onTap: () {
              Navigator.pop(ctx);
              context.read<GoodsCubit>().onAddGood();
            },
          ),
          ListTile(
            leading: Icon(UIConstants.groupIconData,
                color: theme.colorScheme.primary),
            title: Text(context.tr("action_add_group")),
            onTap: () {
              Navigator.pop(ctx);
              context.read<GoodsCubit>().onAddGroup();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchRow(GoodsState state) {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              context.read<GoodsCubit>().onSearchTextChanged(newValue);
            },
            focusNode: searchTextFocusNode,
            showCamera: true,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () => showSortBottomSheet(state),
        ),
      ],
    );
  }

  Widget _buildSummaryInfo(GoodsState state) {
    return SummaryLine([
      SummaryLine.item(
        context.tr("title_folder_count"),
        state.groups.length.toString(),
      ),
      SummaryLine.item(context.tr("goods"), state.goods.length.toString()),
      SummaryLine.item(
        context.tr("title_total_quantity"),
        StringUtils.getQuantityText(state.quantityTotal),
      ),
      SummaryLine.item(
        context.tr("title_total_purchase"),
        CurrencyFormatter.format(context, state.purchasePriceTotal),
      ),
      SummaryLine.item(
        context.tr("title_total_sale"),
        CurrencyFormatter.format(context, state.salePriceTotal),
      ),
    ]);
  }

  Widget _buildList(GoodsState state) {
    final columnCount = state.settings.gridColumnCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.groups.isNotEmpty) ...[
          _buildItemsLayout(
            columnCount: columnCount,
            itemCount: state.groups.length,
            gridExtent: 130,
            itemBuilder: (context, index) {
              final group = state.groups[index];
              return GroupItemRow(
                group,
                (item) => onPressedGroup(group),
                (item) => onLongPressedGroup(group),
                isListTile: columnCount == 1,
              );
            },
          ),
          if (state.goods.isNotEmpty) const SizedBox(height: 12),
        ],
        _buildItemsLayout(
          columnCount: columnCount,
          itemCount: state.goods.length,
          gridExtent: columnCount == 2 ? 200 : 180,
          itemBuilder: (context, index) {
            final good = state.goods[index];
            return GoodItemRow(
              item: good,
              quantity: good.quantity,
              showBarcode: state.settings.showBarcode,
              showDescription: state.settings.showDescription,
              showPurchasePrice: state.settings.showPurchasePrice,
              purchaseDisplayMode: state.settings.purchaseDisplayMode,
              showSalePrice: state.settings.showSalePrice,
              saleDisplayMode: state.settings.saleDisplayMode,
              showMinQuantity: state.settings.showMinQuantity,
              minQuantityColor: state.minQuantityColor ?? Colors.black,
              onGoodTapped: (item) => onPressedGood(good),
              onGoodLongPressed: (item) => onLongPressedGood(good),
              isSelection: state.isSelection,
              isGridTile: columnCount > 1,
              isCompact: columnCount >= 3,
            );
          },
        ),
      ],
    );
  }

  Widget _buildItemsLayout({
    required int columnCount,
    required int itemCount,
    required double gridExtent,
    required Widget Function(BuildContext context, int index) itemBuilder,
  }) {
    if (columnCount == 1) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: itemBuilder,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: gridExtent,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(UIConstants.goodIconData,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(context.tr("no_goods"),
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.4))),
        ],
      ),
    );
  }

  Widget _buildSelectedGroupView(GoodsState state) => Visibility(
        visible: state.selectedGroups.isNotEmpty && state.textSearch.isEmpty,
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ??
                Theme.of(context).colorScheme.surface,
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1))),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: state.selectedGroups.length + 1,
            itemBuilder: (context, index) {
              final isHome = index == 0;
              final groupIndex = index - 1;
              final isLast = index == state.selectedGroups.length;

              return Row(
            children: [
              if (!isHome)
                Icon(Icons.chevron_right,
                    size: 16,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2)),
              InkWell(
                onTap: () =>
                    context
                        .read<GoodsCubit>()
                        .onSelectedGroupTapped(groupIndex),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 10),
                  child: isHome
                      ? Icon(Icons.home_outlined,
                      size: 18,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary)
                      : Text(
                    state.selectedGroups[groupIndex].name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      isLast ? FontWeight.w700 : FontWeight.w500,
                      color: isLast
                          ? Theme
                          .of(context)
                          .colorScheme
                          .onSurface
                          : Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  void showSortBottomSheet(GoodsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (mContext) => DraggableScrollableSheet(
        expand: false,
        builder: (mContext, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: SortGoodWidget(
            onResetAllPressed: () {
              context.read<GoodsCubit>().resetSortOptions();
              Navigator.pop(context);
            },
            onApplyPressed: (setting) {
              context.read<GoodsCubit>().applyFilter(setting);
              Navigator.pop(context);
            },
            setting: state.settings,
          ),
        ),
      ),
    );
  }

  void showListSettingsBottomSheet(GoodsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (mContext) => DraggableScrollableSheet(
        expand: false,
        builder: (mContext, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: ListSettingsGoodWidget(
            onResetAllPressed: () {
              context.read<GoodsCubit>().resetListSettings();
              Navigator.pop(context);
            },
            onApplyPressed: (setting) {
              context.read<GoodsCubit>().applyFilter(setting);
              Navigator.pop(context);
            },
            setting: state.settings,
          ),
        ),
      ),
    );
  }

  void onPressedGood(Good item) async {
    if (widget.isSelection) {
      showAddQuantityAndPriceDialog(item, widget.document!.type);
    } else {
      await Navigator.of(context)
          .pushNamed(Pages.save_good, arguments: {"item": item});
      context.read<GoodsCubit>().loadData();
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
        if (items[index] == context.tr("action_move_to_group")) {
          openSelectGroupForGood(item);
        } else if (items[index] == context.tr("item_history_title")) {
          Navigator.of(context)
              .pushNamed(Pages.good_history, arguments: {'goodId': item.id});
        } else if (items[index] == context.tr("delete")) {
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

  void showDeleteGoodConfirmPopup(Good item) async {
    if (item.id == null) return;
    showCustomAlertDialog(
      context,
      message: sprintf(context.tr("message_confirm_delete"), [item.name]),
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
        if (items[index] == context.tr("action_move_to_group")) {
          openSelectGroupForGroup(item);
        } else if (items[index] == context.tr("action_edit_group")) {
          await Navigator.of(context)
              .pushNamed(Pages.save_group, arguments: {"item": item});
          context.read<GoodsCubit>().loadData();
        } else if (items[index] == context.tr("delete")) {
          context.read<GoodsCubit>().deleteGroup(item.id!);
        }
      },
    );
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

  void _onOverflowMenuSelected(GoodsOverflowMenu item, GoodsState state) {
    switch (item) {
      case GoodsOverflowMenu.importExcel:
        Future.microtask(_importFromExcel);
        break;
      case GoodsOverflowMenu.exportExcel:
        Future.microtask(_exportToExcel);
        break;
      case GoodsOverflowMenu.listSettings:
        context.read<GoodsCubit>().onListSettingsMenuClicked();
        break;
      case GoodsOverflowMenu.help:
        context.read<GoodsCubit>().onHelpMenuClicked();
        break;
    }
  }

  Future<void> _importFromExcel() async {
    final mapping = await showExcelColumnMappingSheet(context);
    if (mapping == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['xlsx', 'xls', 'csv'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      Uint8List? bytes = picked.bytes;
      if (bytes == null && picked.path != null) {
        bytes = await File(picked.path!).readAsBytes();
      }
      if (bytes == null) {
        messenger.showSnackBar(
          snackBarWhenFailureWithText(context.tr("excel_import_failed")),
        );
        return;
      }

      showProgressIndicator(context);
      final count = await context.read<GoodsCubit>().importGoodsFromExcel(
            bytes: bytes,
            fileName: picked.name,
            mapping: mapping,
          );
      if (!mounted) return;
      hideDialog(context);

      if (count == 0) {
        messenger.showSnackBar(
          snackBarWhenFailureWithText(context.tr("excel_import_no_items")),
        );
        return;
      }

      messenger.showSnackBar(
        snackBarWhenSuccessWithText(
          sprintf(context.tr("excel_import_success"), [count.toString()]),
        ),
      );
    } catch (e) {
      if (mounted) hideDialog(context);
      messenger.showSnackBar(
        snackBarWhenFailureWithText(
          sprintf(context.tr("error_with_details"), [e.toString()]),
        ),
      );
    }
  }

  Future<void> _exportToExcel() async {
    final mapping = await showExcelColumnMappingSheet(
      context,
      allowAdjustColumns: false,
    );
    if (mapping == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<GoodsCubit>();
    try {
      showProgressIndicator(context);
      final bytes = cubit.exportGoodsToExcel(mapping);
      if (!mounted) return;
      hideDialog(context);

      if (bytes == null) {
        messenger.showSnackBar(
          snackBarWhenFailureWithText(context.tr("excel_export_no_items")),
        );
        return;
      }

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/${cubit.excelExportFileName()}';
      await File(path).writeAsBytes(bytes, flush: true);
      if (!mounted) return;

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              path,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            ),
          ],
          sharePositionOrigin: ShareUtils.sharePositionOrigin(context),
        ),
      );
      if (!mounted) return;

      messenger.showSnackBar(
        snackBarWhenSuccessWithText(context.tr("excel_saved_and_shared")),
      );
    } catch (e) {
      if (mounted) hideDialog(context);
      messenger.showSnackBar(
        snackBarWhenFailureWithText(
          sprintf(context.tr("error_with_details"), [e.toString()]),
        ),
      );
    }
  }
}
