import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/payment/components/payment_item_row.dart';
import 'package:good_manager/presentation/pages/payment_history/bloc/payment_history_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../widgets/date_item_row.dart';

class PaymentHistoryPage extends StatefulWidget {
  final int documentId;
  PaymentHistoryPage({
    required this.documentId,
  });

  @override
  PaymentHistoryPageState createState() => PaymentHistoryPageState();
}
class PaymentHistoryPageState extends State<PaymentHistoryPage> {

  @override
  void initState() {
    super.initState();
    context.read<PaymentHistoryCubit>().initState(widget.documentId);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentHistoryCubit, PaymentHistoryState>(
        builder: (context, state) => Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(state),
        ),
      listenWhen: (p1, p2) => p1.state != p2.state,
    listener: (context, state) async {}
    );
  }
  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(title: new Text(AppLocalizations.of(context)!.item_history_title)),
    );
  }
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildBody(PaymentHistoryState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }
  Widget _buildContent(PaymentHistoryState state) {
    List<Widget> children = [
      SelectedStoreView(),
      if (state.items.isNotEmpty)
        Expanded(child: _buildStickyListView(state))
      else
        Expanded(child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(UIConstants.paymentIconData, size: 64, color: Theme.of(context).colorScheme.primary,),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.empty_payment, textAlign: TextAlign.center)
          ],
        ))),
      _buildSummaryView(state)
    ];
    return Column(children: children);
  }
  Widget _buildStickyListView(PaymentHistoryState state) {
    var flag = true;
    return StickyGroupedListView<Payment, DateTime>(
      elements: List.of(state.items),
      groupBy: (Payment item) => DateTime(
        item.document!.date.year,
        item.document!.date.month,
        item.document!.date.day,
      ),
      groupSeparatorBuilder: (Payment item) => DateItemRow(item.document!.date),
      itemBuilder: (context, Payment item) {
        flag = !flag;
        return PaymentItemRow(
                          item,
                          flag ? ColorUtils.getItemBgColor1(context) : ColorUtils.getItemBgColor2(context),
                              (item) async {
                        await Navigator.of(context).pushNamed(
                            Pages.save_payment, arguments: {'item': item});
                        context.read<PaymentHistoryCubit>().loadItems();
                      }, (item){});
      },
      itemComparator: (a, b) => b.document!.date.compareTo(a.document!.date),
      order:  StickyGroupedListOrder.DESC,
    );
  }

  Widget _buildSummaryView(PaymentHistoryState state){
    var textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onPrimary
    );
    return Container(
      width: double.infinity,
      height: 20,
      color: Theme.of(context).colorScheme.primary,
      child: IntrinsicHeight(
        child: Row(children: [
          SizedBox(width: 16),
          Text("Count ${state.items.length}", style: textStyle),
          SizedBox(width: 4),
          VerticalDivider(width: 2,color: Colors.white),
          SizedBox(width: 4),
          Text("Total ${Config.currencyFormat.format(state.items.fold<double>(0, (sum, item) => sum + (item.amount ?? 0)))}", style: textStyle,),
        ],),
      )
    );
  }

}