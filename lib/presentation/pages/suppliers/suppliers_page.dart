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
    final theme = Theme.of(context);
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
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(state),
        body: SafeArea(child: _buildBody(state)),
      ),
    );
  }

  AppBar _buildAppBar(SuppliersState state) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        widget.isSelection
            ? context.tr("select_supplier")
            : context.tr("suppliers"),
        style: TextStyle(
            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.read<SuppliersCubit>().onAddButtonClicked(),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () => context.read<SuppliersCubit>().onHelpMenuClick(),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(SuppliersState data) {
    if (data.state is LoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildContent(data);
  }

  Widget _buildContent(SuppliersState data) {
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
                    context.read<SuppliersCubit>().searchTextChanged(newValue);
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
        SummaryLine([
          SummaryLine.item(
            context.tr("suppliers"),
            data.items.length.toString(),
          ),
        ]),
      ],
    );
  }

  Widget get emptyView => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UIConstants.supplierIconData,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              context.tr("no_suppliers"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4)),
            ),
          ],
        ),
      );

  Widget _buildListView(SuppliersState data) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
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
        } else if (items[index] == context.tr("view_documents")) {
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

  void showFilterBottomSheet(SuppliersState state) {
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
}
