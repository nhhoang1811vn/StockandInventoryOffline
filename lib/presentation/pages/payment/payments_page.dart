import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/payment/components/filter_payment_widget.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../dialog/dialog.dart';
import '../../markdown/md_provider_factory.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/payments_cubit.dart';
import 'components/payment_item_row.dart';

class PaymentsPage extends StatefulWidget {
  final PaymentsSetting? setting;
  final int initialIndex;

  PaymentsPage({this.setting, this.initialIndex = 0});

  @override
  PaymentsPageState createState() => PaymentsPageState();
}

class PaymentsPageState extends State<PaymentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FocusNode searchTextFocusNode = FocusNode();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    context.read<PaymentsCubit>().init(widget.setting);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    searchTextFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(PaymentsState state) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        context.tr("payments_title"),
        style: TextStyle(
            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            PaymentType? type = await showAddPaymentBottomSheet(context);
            if (type != null) {
              if (type == PaymentType.inbound) {
                context.read<PaymentsCubit>().onAddInboundPayment();
              } else {
                context.read<PaymentsCubit>().onAddOutboundPayment();
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.category_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed(Pages.payment_categories);
          },
        ),
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () {
            Navigator.of(context).pushNamed(
              Pages.help,
              arguments: {
                "title": context.tr("payments_title"),
                "content":
                    MDProviderFactory.get().getHelpText(HelpType.PAYMENTS),
              },
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(PaymentsState state) {
    if (state.setting == null) {
      return const SizedBox.shrink();
    }

    bool showWarning = (state.setting!.selectedCategoryIds.isNotEmpty ||
        state.setting!.selectedWalletIds.isNotEmpty ||
        state.setting!.selectedCustomerIds.isNotEmpty ||
        state.setting!.selectedSupplierIds.isNotEmpty);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  onTextChanged: (newValue) {
                    setState(() => _searchText = newValue);
                  },
                  focusNode: searchTextFocusNode,
                ),
              ),
              const SizedBox(width: 12),
              Badge(
                isLabelVisible: showWarning,
                child: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => showFilterBottomSheet(state),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(child: _buildTabBarView(state)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: [
        Tab(text: context.tr("all").toUpperCase()),
        Tab(text: context.tr("title_inbound_payment").toUpperCase()),
        Tab(text: context.tr("title_outbound_payment").toUpperCase()),
      ],
    );
  }

  Widget _buildTabBarView(PaymentsState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllItems(state, _filterPayments(state.payments)),
        _buildInboundPayment(state, _filterPayments(state.inboundPayments)),
        _buildOutboundPayment(state, _filterPayments(state.outboundPayments)),
      ],
    );
  }

  List<Payment> _filterPayments(List<Payment> items) {
    final query = _searchText.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          (item.category?.name.toLowerCase().contains(query) ?? false) ||
          (item.wallet?.name.toLowerCase().contains(query) ?? false) ||
          (item.customer?.name.toLowerCase().contains(query) ?? false) ||
          (item.supplier?.name.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Widget _buildAllItems(PaymentsState state, List<Payment> items) {
    return _buildPaymentTab(state, items);
  }

  Widget _buildInboundPayment(PaymentsState state, List<Payment> items) {
    return _buildPaymentTab(state, items);
  }

  Widget _buildOutboundPayment(PaymentsState state, List<Payment> items) {
    return _buildPaymentTab(state, items);
  }

  Widget _buildPaymentTab(PaymentsState state, List<Payment> items) {
    final noResults = _searchText.trim().isNotEmpty && items.isEmpty;
    return Stack(
      children: [
        Visibility(
          child: _buildEmptyView(noResults: noResults),
          visible: items.isEmpty,
        ),
        Visibility(
          child: _buildStickyListView(items, state),
          visible: items.isNotEmpty,
        ),
      ],
    );
  }

  Widget _buildEmptyView({bool noResults = false}) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UIConstants.paymentIconData,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
            const SizedBox(height: 16),
            Text(
              context.tr(noResults ? "no_results_found" : "empty_payment"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
            ),
          ],
        ),
      );

  Widget _buildStickyListView(List<Payment> payments, PaymentsState state) {
    return StickyGroupedListView<Payment, DateTime>(
      stickyHeaderBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elements: List.of(payments),
      groupBy: (Payment payment) => DateTime(
        payment.date.year,
        payment.date.month,
        payment.date.day,
      ),
      groupSeparatorBuilder: (Payment payment) => DateItemRow(payment.date),
      itemBuilder: (context, Payment payment) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: PaymentItemRow(
            payment,
            Colors.transparent,
            (item) => onPressed(item),
            (item) => onLongPressed(item),
            showDate: false,
          ),
        );
      },
      itemComparator: (a, b) => a.date.compareTo(b.date),
      order: state.setting!.sortByDateNewestFirst
          ? StickyGroupedListOrder.DESC
          : StickyGroupedListOrder.ASC,
    );
  }

  void onPressed(Payment item) async {
    context.read<PaymentsCubit>().onPaymentPressed(item);
  }

  void onLongPressed(Payment item) {
    var items = [
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("delete")) {
          showDeleteConfirmPopup(item);
        }
      },
    );
  }

  void showDeleteConfirmPopup(Payment item) async {
    showCustomAlertDialog(
      context,
      message: context.tr("message_confirm_delete_no_args"),
      onPositivePressed: () async {
        hideDialog(context);
        await context.read<PaymentsCubit>().delete(item.id!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<PaymentsCubit, PaymentsState>(
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(state),
        body: SafeArea(child: _buildBody(state)),
      ),
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        if (state.state is OpenSavePaymentPageState) {
          final currentState = state.state as OpenSavePaymentPageState;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_payment,
            arguments: {"item": currentState.item},
          );
          if (result != null) {
            context.read<PaymentsCubit>().loadItems();
          }
        }
      },
    );
  }

  void showFilterBottomSheet(PaymentsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (mContext) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (mContext, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: FilterPaymentWidget(
                onResetAllPressed: () {
                  context.read<PaymentsCubit>().resetAllFilter();
                  Navigator.of(context).pop();
                },
                categories: state.categories,
                wallets: state.wallets,
                customers: state.customers,
                suppliers: state.suppliers,
                onApplyPressed: (setting) {
                  context.read<PaymentsCubit>().applyFilter(setting);
                  Navigator.of(context).pop();
                },
                setting: state.setting!,
              ),
            );
          },
        );
      },
    );
  }

  Future<PaymentType?> showAddPaymentBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<PaymentType>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                context.tr("select_payment_type"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              title: Text(context.tr("title_inbound_payment")),
              onTap: () => Navigator.pop(context, PaymentType.inbound),
            ),
            ListTile(
              title: Text(context.tr("title_outbound_payment")),
              onTap: () => Navigator.pop(context, PaymentType.outbound),
            ),
          ],
        );
      },
    );
  }
}
