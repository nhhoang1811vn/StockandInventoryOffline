import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/history/bloc/item_history_cubit.dart';
import 'package:good_manager/presentation/pages/history/widget/item_history_row.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/util.dart';

class ItemHistoryPage extends StatefulWidget {
  final int goodId;
  final DateTime? start;
  final DateTime? end;

  ItemHistoryPage({required this.goodId, this.start, this.end});

  @override
  ItemHistoryPageState createState() => ItemHistoryPageState();
}

class ItemHistoryPageState extends State<ItemHistoryPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ItemHistoryCubit>()
        .initState(widget.goodId, widget.start, widget.end);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ItemHistoryCubit, ItemHistoryState>(
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
        context.tr("item_history_title"),
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

  Widget _buildBody(ItemHistoryState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }

  Widget _buildContent(ItemHistoryState state) {
    return Column(
      children: [
        Expanded(
          child: state.goodHistories.isNotEmpty
              ? _buildStickyListView(state)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        UIConstants.documentIconData,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr("empty_document"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.4)),
                      ),
                    ],
                  ),
                ),
        ),
        _buildSummaryView(state),
      ],
    );
  }

  Widget _buildStickyListView(ItemHistoryState state) {
    return StickyGroupedListView<GoodHistory, DateTime>(
      stickyHeaderBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elements: List.of(state.goodHistories),
      groupBy: (GoodHistory item) => DateTime(
        item.document!.date.year,
        item.document!.date.month,
        item.document!.date.day,
      ),
      groupSeparatorBuilder: (GoodHistory item) =>
          DateItemRow(item.document!.date),
      itemBuilder: (context, GoodHistory item) {
        return ItemHistoryRow(
            item, Colors.transparent, state.incomingColor,
            state.outgoingColor, (item) async {
          await Navigator.of(context)
              .pushNamed(Pages.save_document, arguments: {'item': item});
          context.read<ItemHistoryCubit>().loadItems();
        });
      },
      itemComparator: (a, b) => a.document!.date.compareTo(b.document!.date),
      order: StickyGroupedListOrder.DESC,
    );
  }

  Widget _buildSummaryView(ItemHistoryState state) {
    String? period;
    if (state.start != null || state.end != null) {
      final start = state.start != null
          ? DateFormatFactory.getDateFormat().format(state.start!)
          : '...';
      final end = state.end != null
          ? DateFormatFactory.getDateFormat().format(state.end!)
          : '...';
      period = '$start - $end';
    }

    return SummaryLine(
      [
        SummaryLine.item(
          context.tr("field_start_period"),
          StringUtils.getQuantityText(state.startPeriodQuantity),
        ),
        SummaryLine.item(
          context.tr("field_in"),
          StringUtils.getQuantityText(state.inQuantity),
        ),
        SummaryLine.item(
          context.tr("field_out"),
          StringUtils.getQuantityText(state.outQuantity),
        ),
        SummaryLine.item(
          context.tr("field_end_period"),
          StringUtils.getQuantityText(state.endPeriodQuantity),
        ),
      ],
      caption: period,
    );
  }
}
