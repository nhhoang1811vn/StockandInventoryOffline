import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/entities/payments_setting.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/payment/components/add_payment_dialog.dart';
import 'package:good_manager/presentation/pages/payment/components/filter_payment_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../markdown/md_provider_factory.dart';
import '../../widgets/date_item_row.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/payments_cubit.dart';
import 'components/payment_item_row.dart';


class PaymentsPage extends StatefulWidget {
  final PaymentsSetting? setting;
  final int initialIndex;
  PaymentsPage({
    this.setting,
    this.initialIndex = 0
  });

  @override
  PaymentsPageState createState() => PaymentsPageState();
}

class PaymentsPageState extends State<PaymentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<PaymentsCubit>().init(widget.setting);
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Pages.help, arguments: {
            "title": AppLocalizations.of(context)!.payments_title,
            "content": MDProviderFactory.get().getHelpText(HelpType.PAYMENTS)
          });
        },
        icon: Icon(Icons.help));
  }

  Widget _buildFilterMenu(PaymentsState state) {
    bool showWarning = (
        state.setting!.selectedCategoryIds.isNotEmpty ||
        state.setting!.selectedWalletIds.isNotEmpty ||
        state.setting!.selectedCustomerIds.isNotEmpty ||
        state.setting!.selectedSupplierIds.isNotEmpty
    );
    return Stack(
      children: [
        IconButton(
            onPressed: () {
              showFilterBottomSheet(state);
            },
            icon: Icon(Icons.filter_alt)),
        if (showWarning)
          Positioned(
            right: 4,
            top: 4,
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 16,
            ),
          )
      ],
    );
  }

  void showFilterBottomSheet(PaymentsState state) {
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
                    ));
              });
        });
  }

  Widget _buildCategoriesMenu() {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Pages.payment_categories);
        },
        icon: Icon(Icons.category));
  }

  PreferredSize _buildAppBar(PaymentsState state) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight * 2 + 20),
        child: AppBar(
            title: new Text(AppLocalizations.of(context)!.payments_title),
            actions: [
              _buildFilterMenu(state),
              _buildCategoriesMenu(),
              _buildHelpMenu()
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(UIConstants.appBarHeight + 20),
              child: Column(
                children: [
                  SelectedStoreView(),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: [
                      Tab(
                          text: AppLocalizations.of(context)!
                              .document_list_tab_all.toUpperCase()),
                      Tab(
                          text: AppLocalizations.of(context)!
                              .title_inbound_payment.toUpperCase()),
                      Tab(
                          text: AppLocalizations.of(context)!
                              .title_outbound_payment.toUpperCase()),
                    ],
                  )
                ],
              ),
            )));
  }
  Widget _buildAllItems(PaymentsState state) {
    return Column(
      children: [
        Expanded(
            child: Stack(
              children: [
                Visibility(
                  child: emptyView,
                  visible: state.payments.isEmpty,
                ),
                Visibility(
                  child: _buildStickyListView(state.payments, state),
                  visible: state.payments.isNotEmpty,
                )
              ],
            )),
      ],
    );
  }
  Widget _buildInboundPayment(PaymentsState state) {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            Visibility(
              child: emptyView,
              visible: state.inboundPayments.isEmpty,
            ),
            Visibility(
              child: _buildStickyListView(state.inboundPayments, state),
              visible: state.inboundPayments.isNotEmpty,
            )
          ],
        )),
      ],
    );
  }

  Widget _buildOutboundPayment(PaymentsState state) {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            Visibility(
              child: emptyView,
              visible: state.outboundPayments.isEmpty,
            ),
            Visibility(
              child: _buildStickyListView(state.outboundPayments, state),
              visible: state.outboundPayments.isNotEmpty,
            )
          ],
        )),
      ],
    );
  }

  Widget get emptyView => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              UIConstants.paymentIconData,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.empty_payment,
                    textAlign: TextAlign.center))
          ]);
  Widget _buildStickyListView(List<Payment> payments, PaymentsState state) {
    var flag = true;
    return StickyGroupedListView<Payment, DateTime>(
      elements: List.of(payments),
      groupBy: (Payment payment) => DateTime(
        payment.date.year,
        payment.date.month,
        payment.date.day,
      ),
      groupSeparatorBuilder: (Payment payment) => DateItemRow(payment.date),
      itemBuilder: (context, Payment payment) {
        flag = !flag;
        return PaymentItemRow(
          payment,
          // Alternate background colors
          flag ? ColorUtils.getItemBgColor1(context) : ColorUtils.getItemBgColor2(context),
              (item) => onPressed(item),
              (item) => onLongPressed(item),
        );
      },
      itemComparator: (a, b) => b.date.compareTo(a.date),
      order: state.setting!.sortByDateNewestFirst ? StickyGroupedListOrder.DESC :StickyGroupedListOrder.ASC,
    );
  }

  void onPressed(Payment item) async {
    context.read<PaymentsCubit>().onPaymentPressed(item);
  }

  void onLongPressed(Payment item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteConfirmPopup(item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }

  void showDeleteConfirmPopup(Payment item) async {
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return AlertDialog(
            title:
                Text(AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(
              AppLocalizations.of(context)!.message_confirm_delete_no_args,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () async {
                  await context.read<PaymentsCubit>().delete(item.id!);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentsCubit, PaymentsState>(
        builder: (context, state) => Scaffold(
            appBar: _buildAppBar(state),
            body: TabBarView(controller: _tabController, children: [
              _buildAllItems(state),
              _buildInboundPayment(state),
              _buildOutboundPayment(state),
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (_tabController.index == 1) {
                  context.read<PaymentsCubit>().onAddInboundPayment();
                } else if (_tabController.index == 2) {
                  context.read<PaymentsCubit>().onAddOutboundPayment();
                } else {
                  //show dialog
                  PaymentType? type = await showDialog(
                      context: context, builder: (_) => AddPaymentDialog(), barrierDismissible: true);
                  if (type != null) {
                    if (type == PaymentType.inbound){
                      context.read<PaymentsCubit>().onAddInboundPayment();
                    }else{
                      context.read<PaymentsCubit>().onAddOutboundPayment();
                    }
                  }
                }
              },
              // onPressed: () {
              //   if (_tabController.index == 0 || _tabController.index == 1) {
              //     context.read<PaymentsCubit>().onAddInboundPayment();
              //   } else {
              //     context.read<PaymentsCubit>().onAddOutboundPayment();
              //   }
              // },
              child: Icon(Icons.add),
            )),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {
          if (state.state is OpenSavePaymentPageState) {
            final currentState = state.state as OpenSavePaymentPageState;
            final result = await Navigator.of(context).pushNamed(
                Pages.save_payment,
                arguments: {"item": currentState.item});
            if (result != null) {
              context.read<PaymentsCubit>().loadItems();
            }
          }
        });
  }
}
