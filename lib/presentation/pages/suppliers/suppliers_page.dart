import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/suppliers/components/supplier_item_row.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/free_limits.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/bloc.dart';
import 'components/filter_supplier_widget.dart';

class SuppliersPage extends StatefulWidget {
  final bool isSelection;

  SuppliersPage({Key? key, required this.isSelection});

  @override
  SuppliersPageState createState() => SuppliersPageState();
}

class SuppliersPageState extends State<SuppliersPage> {
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<SuppliersCubit>().initState(widget.isSelection);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuppliersCubit, SuppliersState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        if (state.state is OpenSaveSupplierPageState) {
          final currentState = state.state as OpenSaveSupplierPageState;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_supplier,
            arguments: {"item": currentState.item},
          );
          if (result != null) {
            context.read<SuppliersCubit>().loadItems();
          }
        } else if (state.state is OpenHelpPageState) {
          Navigator.of(context).pushNamed(
            Pages.help,
            arguments: {
              "title": context.tr("suppliers"),
              "content": MDProviderFactory.get()
                  .getHelpText(HelpType.SUPPLIER_AND_CUSTOMER),
            },
          );
        } else if (state.state is OpenBuySubscriptionDialogState) {
          showBuySubscriptionDialog(
            context,
            message: sprintf(
              context.tr("buy_subscription_to_add_more_entity"),
              [FreeLimits.supplierLimit],
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        //drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 5, storeName: storage.getSelectedStoreName(),),
        appBar: _buildAppBar(state),
        body: _buildBody(state),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<SuppliersCubit>().onAddButtonClicked(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(SuppliersState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(
          widget.isSelection
              ? context.tr("select_supplier")
              : context.tr("suppliers"),
        ),
        actions: [
          _buildSearchMenu(state),
          _buildFilterMenu(state),
          _buildHelpMenu(),
        ],
      ),
    );
  }

  Widget _buildBody(SuppliersState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(SuppliersState data) {
    List<Widget> children = [
      SelectedStoreView(),
      Visibility(
        visible: data.showSearchBar,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              context.read<SuppliersCubit>().searchTextChanged(newValue);
            },
            focusNode: searchTextFocusNode,
          ),
        ),
      ),

      // Visibility(child: _buildSearchBar(data), visible: data.showSearchBar),
      Expanded(
        child: Stack(
          children: [
            Visibility(
              child: emptyView,
              visible: data.items.isEmpty,
            ),
            Visibility(
              child: _buildListView(data),
              visible: data.items.isNotEmpty,
            ),
          ],
        ),
      ),
    ];
    return Column(children: children);
  }

  Widget get emptyView => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            UIConstants.supplierIconData,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              context.tr("no_suppliers"),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  Widget _buildListView(SuppliersState data) {
    return ListView.separated(
      separatorBuilder: (context, index) => buildDivider(),
      itemBuilder: (BuildContext context, index) {
        Supplier item = data.items[index];

        return SupplierItemRow(
          item,
          onPressed: _handleOnPressed,
          onLongPressed: handleOnLongPressed,
          onSendEmailPressed: (item) {
            NavigatorUtils.openUrl("mailto:${item.email}");
          },
          onSendSmsPressed: (item) {
            NavigatorUtils.openUrl("sms:${item.phone}");
          },
          onPhoneCallPressed: (item) {
            NavigatorUtils.openUrl("tel:${item.phone}");
          },
        );
      },
      itemCount: data.items.length,
    );
  }

  void _handleOnPressed(Supplier item) async {
    if (widget.isSelection) {
      Navigator.of(context).pop(item);
    } else {
      context.read<SuppliersCubit>().onAddItem(item);
    }
  }

  void handleOnLongPressed(Supplier item) {
    var items = [
      context.tr("delete"),
      context.tr("view_documents"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("delete")) {
          showDeleteConfirmPopup(item);
        } else if (items[index] ==
            context.tr("view_documents")) {
          await Navigator.of(context).pushNamed(
            Pages.documents_history,
            arguments: {
              'supplierId': item.id,
            },
          );
        }
      },
    );
  }

  void showDeleteConfirmPopup(Supplier item) async {
    showCustomAlertDialog(
      context,
      message: sprintf(
        context.tr("message_confirm_delete"),
        [item.name],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        await context.read<SuppliersCubit>().delete(item.id!);
      },
    );
  }

  Widget _buildSearchMenu(SuppliersState state) {
    return IconButton(
      onPressed: () {
        if (!state.showSearchBar) {
          searchTextFocusNode.requestFocus();
        }
        context.read<SuppliersCubit>().onShowSearchBarMenuClicked();
      },
      icon: Icon(
        Icons.search,
        color: state.showSearchBar
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _buildFilterMenu(SuppliersState state) {
    bool showWarning = state.settings.sortByName != SortByText.no_sort;
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

  void showFilterBottomSheet(SuppliersState state) {
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
              child: FilterSupplierWidget(
                onResetAllPressed: () {
                  context.read<SuppliersCubit>().resetAllFilter();
                  Navigator.of(context).pop();
                },
                onApplyPressed: (setting) {
                  context.read<SuppliersCubit>().applyFilter(setting);
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

  Widget _buildHelpMenu() {
    return IconButton(
      onPressed: () {
        context.read<SuppliersCubit>().onHelpMenuClick();
      },
      icon: Icon(Icons.help),
    );
  }
}
