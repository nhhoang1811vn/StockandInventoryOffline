import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../markdown/md_provider_factory.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/payments_cubit.dart';
import 'components/payment_item_row.dart';

class PaymentsPage extends StatefulWidget {
  PaymentsPage();

  @override
  PaymentsPageState createState() => PaymentsPageState();
}

class PaymentsPageState extends BaseStateWidget<PaymentsPage> with SingleTickerProviderStateMixin{
  //final _key = GlobalKey<ExpandableFabState>();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    context.read<PaymentsCubit>().init();
    _tabController = TabController(length: 2, vsync: this);
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
  PreferredSize _buildAppBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight * 2 + 20),
        child: AppBar(
            title: new Text(AppLocalizations.of(context)!.payments_title),
            actions: [
              _buildHelpMenu()
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(UIConstants.appBarHeight + 20),
              child: Column(
                children: [
                  SelectedStoreView(),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).colorScheme.onPrimary,
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.title_incoming_payment),
                      Tab(text: AppLocalizations.of(context)!.title_outgoing_payment),
                    ],
                  )
                ],
              ),
            )));
    //return AppBar(title: Text(AppLocalizations.of(context)!.payments_title))
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(PaymentsState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }

  Widget _buildContent(PaymentsState state) {
    return TabBarView(children: [_buildIncomingPayment(state), _buildOutgoingPayment(state)]);
  }

  Widget _buildIncomingPayment(PaymentsState state) {
    return Expanded(
        child: Stack(
      children: [
        Visibility(
          child: emptyView,
          visible: state.incomingItems.isEmpty,
        ),
        Visibility(
          child: _buildListView(state.incomingItems),
          visible: state.incomingItems.isNotEmpty,
        )
      ],
    ));
  }

  Widget _buildOutgoingPayment(PaymentsState state) {
    return Expanded(
        child: Stack(
      children: [
        Visibility(
          child: emptyView,
          visible: state.outgoingItems.isEmpty,
        ),
        Visibility(
          child: _buildListView(state.outgoingItems),
          visible: state.outgoingItems.isNotEmpty,
        )
      ],
    ));
  }

  Widget get emptyView =>
      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Icon(
          UIConstants.paymentIconData,
          size: 60,
          color: AppColors.primaryColor,
        ),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              AppLocalizations.of(context)!.empty_payment,
              textAlign: TextAlign.center,
              style: AppStyle.getEmptyTextStyle(),
            ))
      ]);

  Widget _buildListView(List<Payment> items) => ListView.builder(
      itemBuilder: (BuildContext context, index) {
        Payment item = items[index];
        return PaymentItemRow(item, (item) {
          onPressed(item);
        }, (item) {
          onLongPressed(item);
        });
      },
      itemCount: items.length);

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
            title: Text(AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(
              AppLocalizations.of(context)!.message_confirm_delete_no_args,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.action_cancel)),
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
  Widget buildWidget(BuildContext context) {
    return BlocConsumer<PaymentsCubit, PaymentsState>(
        builder: (context, state) => Scaffold(
            appBar: _buildAppBar(),
            body: TabBarView(controller: _tabController,children: [
              _buildIncomingPayment(state),
              _buildOutgoingPayment(state)
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (_tabController.index == 0){
                  context.read<PaymentsCubit>().onAddIncomingPayment();
                }else{
                  context.read<PaymentsCubit>().onAddOutgoingPayment();
                }
              },
              child: Icon(Icons.add),
            )),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {
          if (state.state is OpenSavePaymentPageState) {
            final currentState = state.state as OpenSavePaymentPageState;
            final result =
                await Navigator.of(context).pushNamed(Pages.save_payment, arguments: {"item": currentState.item});
            if (result != null) {
              context.read<PaymentsCubit>().loadItems();
            }
          }
        });
  }
}
