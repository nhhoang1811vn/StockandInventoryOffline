import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/good_history.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/models/list_item.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/history/bloc/item_history_cubit.dart';
import 'package:good_manager/presentation/pages/history/widget/item_history_row.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../widgets/date_item_row.dart';

class ItemHistoryPage extends StatefulWidget {
  final int goodId;
  final DateTime? start;
  final DateTime? end;
  ItemHistoryPage({
    required this.goodId,
    this.start,
    this.end
  });

  @override
  ItemHistoryPageState createState() => ItemHistoryPageState();
}
class ItemHistoryPageState extends State<ItemHistoryPage> {

  @override
  void initState() {
    super.initState();
    context.read<ItemHistoryCubit>().initState(widget.goodId, widget.start, widget.end);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemHistoryCubit, ItemHistoryState>(
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
        Expanded(child: _buildListView(state))
      else
        Expanded(child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(UIConstants.documentIconData, size: 64, color: Theme.of(context).colorScheme.primary,),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.empty_document, textAlign: TextAlign.center)
          ],
        ))),
      _buildSummaryView(state)
    ];
    return Column(children: children);
  }
  Widget _buildListView(ItemHistoryState data) {
    bool flag = true;
    return ListView.builder(
        itemBuilder: (BuildContext context, index) {
          ListItem item = data.items[index];
          flag = !flag;
          if (item is HeaderItem){
            flag = true;
            return DateItemRow(item.date);
          }else if (item is GoodHistoryListItem){
            flag = !flag;
            return ItemHistoryRow(item.goodHistory, flag ? ColorUtils.getItemBgColor1(context) : ColorUtils.getItemBgColor2(context),(item) async {
              await Navigator.of(context).pushNamed(
                  Pages.save_document, arguments: {'item': item});
              context.read<ItemHistoryCubit>().loadItems();
            });
          }else{
            return SizedBox();
          }

        },
        itemCount: data.items.length);
  }
  Widget _buildSummaryView(ItemHistoryState state){
    return Container(
      width: double.infinity,
      color: ColorUtils.getHeaderBgColor(context),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        if (state.start != null)
          Text("${AppLocalizations.of(context)!.start_date}:${DateFormatFactory.getDateFormat().format(state.start!)}"),
        if (state.end != null)
          Text("${AppLocalizations.of(context)!.end_date}:${DateFormatFactory.getDateFormat().format(state.end!)}"),
        Row(children: [
          Text("${AppLocalizations.of(context)!.field_start_period}: ${Config.currencyFormat.format(state.startPeriodQuantity)}"),
          SizedBox(width: 4,),
          Text("${AppLocalizations.of(context)!.field_in}: ${Config.currencyFormat.format(state.inQuantity)}"),
          SizedBox(width: 4,),
          Text("${AppLocalizations.of(context)!.field_out}: ${Config.currencyFormat.format(state.outQuantity)}"),
          SizedBox(width: 4,),
          Text("${AppLocalizations.of(context)!.field_end_period}: ${Config.currencyFormat.format(state.endPeriodQuantity)}"),
        ],)
      ],) 
    );
  }

}