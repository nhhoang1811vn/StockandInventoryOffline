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
    final theme = Theme.of(context);
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
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(state),
        body: SafeArea(child: _buildBody(state)),
      ),
    );
  }

  AppBar _buildAppBar(CustomersState state) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        widget.isSelection
            ? context.tr("select_customer")
            : context.tr("customers"),
        style: TextStyle(
            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.read<CustomersCubit>().onAddButtonClicked(),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () => context.read<CustomersCubit>().onHelpMenuClick(),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(CustomersState data) {
    if (data.state is LoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildContent(data);
  }

  Widget _buildContent(CustomersState data) {
    bool showWarning = data.settings.sortByName != SortByText.no_sort;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  onTextChanged: (newValue) {
                    context.read<CustomersCubit>().searchTextChanged(newValue);
                  },
                  focusNode: searchTextFocusNode,
                ),
              ),
              const SizedBox(width: 12),
              Badge(
                isLabelVisible: showWarning,
                child: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => showFilterBottomSheet(data),
                ),
              ),
            ],
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
      ],
    );
  }

  Widget get emptyView => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UIConstants.customerIconData,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
            const SizedBox(height: 16),
            Text(
              context.tr("no_customers"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
            ),
          ],
        ),
      );

  Widget _buildListView(CustomersState data) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
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
        if (items[index] == context.tr("view_documents")) {
          await Navigator.of(context).pushNamed(
            Pages.documents_history,
            arguments: {
              'customerId': item.id,
            },
          );
        } else if (items[index] == context.tr("delete")) {
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

  void showFilterBottomSheet(CustomersState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext mContext) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (mContext, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
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
}
