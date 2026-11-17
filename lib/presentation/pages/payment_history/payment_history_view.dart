import 'package:good_manager/util/dimen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/payment/components/payment_item_row.dart';
import 'package:good_manager/presentation/pages/payment_history/bloc/payment_history_cubit.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';

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
    final theme = Theme.of(context);
    return BlocConsumer<PaymentHistoryCubit, PaymentHistoryState>(
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: SafeArea(child: _buildBody(state)),
      ),
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {},
    );
  }

  AppBar _buildAppBar() {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        context.tr("action_view_payments"),
        style: TextStyle(
            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
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
    return Column(
      children: [
        Expanded(
          child: state.items.isNotEmpty
              ? _buildStickyListView(state)
              : _buildEmptyView(),
        ),
        _buildSummaryView(state),
      ],
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            UIConstants.paymentIconData,
            size: 64,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr("empty_payment"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyListView(PaymentHistoryState state) {
    return ResetOnShrink(
        itemCount: state.items.length,
        child: StickyGroupedListView<Payment, DateTime>(
          stickyHeaderBackgroundColor:
              Theme.of(context).scaffoldBackgroundColor,
          elements: List.of(state.items),
          padding: const EdgeInsets.only(bottom: 16),
          groupBy: (Payment item) => DateTime(
            item.date.year,
            item.date.month,
            item.date.day,
          ),
          groupSeparatorBuilder: (Payment item) => DateItemRow(item.date),
          itemBuilder: (context, Payment item) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.screenPadding),
              child: PaymentItemRow(
                item,
                Colors.transparent,
                (item) async {
                  await Navigator.of(context)
                      .pushNamed(Pages.save_payment, arguments: {'item': item});
                  context.read<PaymentHistoryCubit>().loadItems();
                },
                (item) {},
                showDate: false,
              ),
            );
          },
          itemComparator: (a, b) => b.date.compareTo(a.date),
          order: StickyGroupedListOrder.DESC,
        ));
  }

  Widget _buildSummaryView(PaymentHistoryState state) {
    final total =
        state.items.fold<double>(0, (sum, item) => sum + (item.amount ?? 0));
    return SummaryLine([
      SummaryLine.item(context.tr("count"), state.items.length.toString()),
      SummaryLine.item(
          context.tr("total"), CurrencyFormatter.format(context, total)),
    ]);
  }
}
