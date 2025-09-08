import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/customers/components/customer_item_row.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/free_limits.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/bloc.dart';
import 'components/filter_customer_widget.dart';

class CustomersPage extends StatefulWidget {
  final bool isSelection;

  CustomersPage({Key? key, required this.isSelection});

  @override
  CustomersPageState createState() => CustomersPageState();
}

class CustomersPageState extends State<CustomersPage> {
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<CustomersCubit>().initState(widget.isSelection);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomersCubit, CustomersState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        if (state.state is OpenSaveCustomerPageState) {
          final currentState = state.state as OpenSaveCustomerPageState;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_customer,
            arguments: {"item": currentState.item},
          );
          if (result != null) {
            context.read<CustomersCubit>().loadItems();
          }
        } else if (state.state is OpenHelpPageState) {
          Navigator.of(context).pushNamed(
            Pages.help,
            arguments: {
              "title": context.tr("customers"),
              "content": MDProviderFactory.get()
                  .getHelpText(HelpType.SUPPLIER_AND_CUSTOMER),
            },
          );
        } else if (state.state is OpenBuySubscriptionDialogState) {
          showBuySubscriptionDialog(
            context,
            message: sprintf(
              context.tr("buy_subscription_to_add_more_entity"),
              [FreeLimits.customerLimit],
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        appBar: _buildAppBar(state),
        body: _buildBody(state),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<CustomersCubit>().onAddButtonClicked(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(CustomersState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(
          widget.isSelection
              ? context.tr("select_customer")
              : context.tr("customers"),
        ),
        actions: [
          _buildSearchMenu(state),
          _buildFilterMenu(state),
          _buildHelpMenu(),
        ],
      ),
    );
  }

  Widget _buildBody(CustomersState data) {
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

  Widget _buildContent(CustomersState data) {
    List<Widget> children = [
      SelectedStoreView(),
      Visibility(
        visible: data.showSearchBar,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              context.read<CustomersCubit>().searchTextChanged(newValue);
            },
            focusNode: searchTextFocusNode,
          ),
        ),
      ),
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
              context.tr("no_customers"),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  Widget _buildListView(CustomersState data) {
    return ListView.separated(
      separatorBuilder: (context, index) => buildDivider(),
      itemBuilder: (BuildContext context, index) {
        Customer item = data.items[index];
        return CustomerItemRow(item, (item) {
          onPressed(item);
        }, (item) {
          onLongPressed(item);
        }, (item) {
          NavigatorUtils.openUrl("mailto:${item.email}");
        }, (item) {
          NavigatorUtils.openUrl("sms:${item.phone}");
        }, (item) {
          NavigatorUtils.openUrl("tel:${item.phone}");
        });
      },
      itemCount: data.items.length,
    );
  }

  void onPressed(Customer item) async {
    if (widget.isSelection) {
      Navigator.of(context).pop(item);
    } else {
      context.read<CustomersCubit>().onAddItem(item);
    }
  }

  void onLongPressed(Customer item) {
    var items = [
      context.tr("view_documents"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] ==
            context.tr("view_documents")) {
          await Navigator.of(context).pushNamed(
            Pages.documents_history,
            arguments: {
              'customerId': item.id,
            },
          );
        } else if (items[index] ==
            context.tr("delete")) {
          showDeleteConfirmPopup(item);
        }
      },
    );
  }

  void showDeleteConfirmPopup(Customer item) async {
    showCustomAlertDialog(
      context,
      message: sprintf(
        context.tr("message_confirm_delete"),
        [item.name],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        await context.read<CustomersCubit>().delete(item.id!);
      },
    );
  }

  Widget _buildSearchMenu(CustomersState state) {
    return IconButton(
      onPressed: () {
        if (!state.showSearchBar) {
          searchTextFocusNode.requestFocus();
        }
        context.read<CustomersCubit>().onShowSearchBarMenuClicked();
      },
      icon: Icon(
        Icons.search,
        color: state.showSearchBar
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _buildFilterMenu(CustomersState state) {
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

  void showFilterBottomSheet(CustomersState state) {
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
              child: FilterCustomerWidget(
                onResetAllPressed: () {
                  context.read<CustomersCubit>().resetAllFilter();
                  Navigator.of(context).pop();
                },
                onApplyPressed: (setting) {
                  context.read<CustomersCubit>().applyFilter(setting);
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
        context.read<CustomersCubit>().onHelpMenuClick();
      },
      icon: Icon(Icons.help),
    );
  }
}
