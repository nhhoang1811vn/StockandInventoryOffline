import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/entities/payments_setting.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/payment/components/filter_payment_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../markdown/md_provider_factory.dart';
import '../../models/list_item.dart';
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
    bool showWarning = (state.setting?.selectedCategoryId != null ||
        state.setting?.selectedWalletId != null);
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
                              .show_all),
                      Tab(
                          text: AppLocalizations.of(context)!
                              .title_inbound_payment),
                      Tab(
                          text: AppLocalizations.of(context)!
                              .title_outbound_payment),
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
                  visible: state.items.isEmpty,
                ),
                Visibility(
                  child: _buildListView(state.items),
                  visible: state.items.isNotEmpty,
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
              visible: state.inboundItems.isEmpty,
            ),
            Visibility(
              child: _buildListView(state.inboundItems),
              visible: state.inboundItems.isNotEmpty,
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
              visible: state.outboundItems.isEmpty,
            ),
            Visibility(
              child: _buildListView(state.outboundItems),
              visible: state.outboundItems.isNotEmpty,
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

  Widget _buildListView(List<ListItem> items) {
   
    var flag = true;
    return ListView.builder(
        itemBuilder: (BuildContext context, index) {
          final item = items[index];
          if (item is HeaderItem){
            flag = true;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: ColorUtils.getHeaderBgColor(context),
              child: Text(
                DateFormatFactory.getDateFormat().format(item.date),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            );
          }else if (item is PaymentListItem){
            flag = !flag;
            return PaymentItemRow(item.payment, flag ? ColorUtils.getItemBgColor1(context) : ColorUtils.getItemBgColor2(context) , (item) {
              onPressed(item);
            }, (item) {
              onLongPressed(item);
            });
          }
        },
        itemCount: items.length);
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
              onPressed: () {
                if (_tabController.index == 0 || _tabController.index == 1) {
                  context.read<PaymentsCubit>().onAddInboundPayment();
                } else {
                  context.read<PaymentsCubit>().onAddOutboundPayment();
                }
              },
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
