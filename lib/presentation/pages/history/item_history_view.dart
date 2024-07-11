import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/good_history.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/history/bloc/item_history_cubit.dart';
import 'package:good_manager/presentation/pages/history/widget/item_history_row.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

class ItemHistoryPage extends StatefulWidget {
  int goodId;
  DateTime? start;
  DateTime? end;
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
        Expanded(child: Center(child: Text("Không có dữ liệu")))
    ];
    return Column(children: children);
  }
  Widget _buildListView(ItemHistoryState data) => ListView.separated(
      itemBuilder: (BuildContext context, index) {
        GoodHistory item = data.items[index];
        return ItemHistoryRow(item, (item) async{
            var result = await Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
            context.read<ItemHistoryCubit>().loadItems();
        });
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey[500]);
      },
      itemCount: data.items.length);

}