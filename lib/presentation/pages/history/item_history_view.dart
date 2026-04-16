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
    return BlocConsumer<ItemHistoryCubit, ItemHistoryState>(
      builder: (context, state) => Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(state),
      ),
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {},
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(context.tr("item_history_title")),
      ),
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
    List<Widget> children = [
      SelectedStoreView(),
      if (state.items.isNotEmpty)
        Expanded(child: _buildStickyListView(state))
      else
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  UIConstants.documentIconData,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 16),
                Text(
                  context.tr("empty_document"),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      _buildSummaryView(state),
    ];
    return Column(children: children);
  }

  Widget _buildStickyListView(ItemHistoryState state) {
    var flag = true;
    return StickyGroupedListView<GoodHistory, DateTime>(
      elements: List.of(state.goodHistories),
      groupBy: (GoodHistory item) => DateTime(
        item.document!.date.year,
        item.document!.date.month,
        item.document!.date.day,
      ),
      groupSeparatorBuilder: (GoodHistory item) =>
          DateItemRow(item.document!.date),
      itemBuilder: (context, GoodHistory item) {
        flag = !flag;
        return ItemHistoryRow(
            item,
            flag
                ? ColorUtils.getItemBgColor1(context)
                : ColorUtils.getItemBgColor2(context),
            state.incomingColor,
            state.outgoingColor, (item) async {
          await Navigator.of(context)
              .pushNamed(Pages.save_document, arguments: {'item': item});
          context.read<ItemHistoryCubit>().loadItems();
        });
      },
      itemComparator: (a, b) => b.document!.date.compareTo(a.document!.date),
      order: StickyGroupedListOrder.DESC,
    );
  }

  // Widget _buildListView(ItemHistoryState state) {
  //   bool flag = true;
  //   return ListView.builder(
  //       itemBuilder: (BuildContext context, index) {
  //         ListItem item = state.items[index];
  //         flag = !flag;
  //         if (item is HeaderItem){
  //           flag = true;
  //           return DateItemRow(item.date);
  //         }else if (item is GoodHistoryListItem){
  //           flag = !flag;
  //           return ItemHistoryRow(
  //               item.goodHistory,
  //               flag ? ColorUtils.getItemBgColor1(context) : ColorUtils.getItemBgColor2(context),
  //               state.incomingColor,
  //               state.outgoingColor,
  //                   (item) async {
  //             await Navigator.of(context).pushNamed(
  //                 Pages.save_document, arguments: {'item': item});
  //             context.read<ItemHistoryCubit>().loadItems();
  //           });
  //         }else{
  //           return SizedBox();
  //         }
  //       },
  //       itemCount: state.items.length);
  // }
  Widget _buildSummaryView(ItemHistoryState state) {
    var textColor = Theme.of(context).colorScheme.onPrimary;
    var textStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.start != null)
            Text(
              "${context.tr("start_date")}:${DateFormatFactory.getDateFormat().format(state.start!)}",
              style: textStyle,
            ),
          if (state.end != null)
            Text(
              "${context.tr("end_date")}:${DateFormatFactory.getDateFormat().format(state.end!)}",
              style: textStyle,
            ),
          IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  "${context.tr("field_start_period")}: ${StringUtils.getQuantityText(state.startPeriodQuantity)}",
                  style: textStyle,
                ),
                SizedBox(
                  width: 4,
                ),
                VerticalDivider(
                  width: 2,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${context.tr("field_in")}: ${StringUtils.getQuantityText(state.inQuantity)}",
                  style: textStyle,
                ),
                SizedBox(
                  width: 4,
                ),
                VerticalDivider(
                  width: 2,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${context.tr("field_out")}: ${StringUtils.getQuantityText(state.outQuantity)}",
                  style: textStyle,
                ),
                SizedBox(
                  width: 4,
                ),
                VerticalDivider(
                  width: 2,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${context.tr("field_end_period")}: ${StringUtils.getQuantityText(state.endPeriodQuantity)}",
                  style: textStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
