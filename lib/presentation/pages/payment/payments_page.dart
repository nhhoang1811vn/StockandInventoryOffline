import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/app_style.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/style_size.dart';

import '../base/base_state.dart';
import '../pages.dart';
import 'bloc/payments_cubit.dart';
import 'components/payment_item_row.dart';

class PaymentsPage extends StatefulWidget {
  final int documentId;

  PaymentsPage(this.documentId);

  @override
  PaymentsPageState createState() => PaymentsPageState();
}

class PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentsCubit>().init(widget.documentId);
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(title: new Text(AppLocalizations.of(context)!.payments_title)),
    );
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
  TextStyle headerStyle = TextStyle(fontSize: TextSize.large, color: Palette.white);
  TextStyle subStyle = TextStyle(fontSize: TextSize.medium, color: Palette.white);
  Widget _buildTopWidget(PaymentsState state) {
    return Container(
      padding: EdgeInsets.all(16),
      color: UIConstants.primaryColor,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(children: [Text("${Config.currencyFormat.format(state.invoiced - state.paid)}", style: headerStyle,), Text(AppLocalizations.of(context)!.payment_due_pending, style: subStyle,)],),
          SizedBox(height: 16),
          Row(children: [
            Expanded(child: Column(children: [Text("${Config.currencyFormat.format(state.invoiced)}", style: headerStyle), Text(AppLocalizations.of(context)!.payment_invoiced, style: subStyle)])),
            Expanded(child: Column(children: [Text("${Config.currencyFormat.format(state.paid)}", style: headerStyle), Text(AppLocalizations.of(context)!.payment_paid, style: subStyle)])),
          ],)
         ],
      ),
    );
  }

  Widget _buildContent(PaymentsState state) {
    List<Widget> children = [
      _buildTopWidget(state),
      Expanded(
          child: Stack(children: [
        Visibility(
          child: emptyView,
          visible: state.items.isEmpty,
        ),
        Visibility(
          child: _buildListView(state),
          visible: state.items.isNotEmpty,
        )
      ]))
    ];
    return Column(children: children);
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

  Widget _buildListView(PaymentsState data) => ListView.separated(
      itemBuilder: (BuildContext context, index) {
        Payment item = data.items[index];
        return PaymentItemRow(item, (item) {
          onPressed(item);
        }, (item) {
          onLongPressed(item);
        });
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey[500]);
      },
      itemCount: data.items.length);

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
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentsCubit, PaymentsState>(
        builder: (context, state) => Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(state),
            floatingActionButton: FloatingActionButton(
              onPressed:() => context.read<PaymentsCubit>().onAddNewPaymentButtonPressed(),
              child: Icon(Icons.add),
            )),
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {
          if (state.state is OpenSavePaymentPageState) {
            final currentState = state.state as OpenSavePaymentPageState;
            final result =
                await Navigator.of(context).pushNamed(Pages.save_payment,
                    arguments: {
                      "item": currentState.item
                    });
            if (result != null) {
              //Payment item = result as Payment;
              //context.read<PaymentsCubit>().updateDocumentId(item.documentId);
              context.read<PaymentsCubit>().loadItems();
            }
          }
        });
  }
}
