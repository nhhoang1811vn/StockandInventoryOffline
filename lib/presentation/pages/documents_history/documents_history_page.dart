import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/models/list_item.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/presentation/pages/documents/components/document_item_row.dart';
import 'package:good_manager/presentation/pages/documents_history/bloc/documents_history_cubit.dart';
import 'package:good_manager/presentation/pages/history/bloc/item_history_cubit.dart';
import 'package:good_manager/presentation/pages/history/widget/item_history_row.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/payment/components/payment_item_row.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../widgets/date_item_row.dart';

class DocumentsHistoryPage extends StatefulWidget {
  final int? supplierId;
  final int? customerId;
  final DateTime? start;
  final DateTime? end;
  DocumentsHistoryPage({
    this.supplierId,
    this.customerId,
    this.start,
    this.end
  });

  @override
  DocumentsHistoryPageState createState() => DocumentsHistoryPageState();
}
class DocumentsHistoryPageState extends State<DocumentsHistoryPage> {

  @override
  void initState() {
    super.initState();
    context.read<DocumentsHistoryCubit>().initState(widget.supplierId, widget.customerId, widget.start, widget.end);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsHistoryCubit, DocumentsHistoryState>(
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
  Widget _buildBody(DocumentsHistoryState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }
  Widget _buildContent(DocumentsHistoryState state) {
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
      //_buildSummaryView(state)
    ];
    return Column(children: children);
  }
  Widget _buildListView(DocumentsHistoryState data) {
    //bool flag = true;
    return ListView.builder(
        itemBuilder: (BuildContext context, index) {
          ListItem item = data.items[index];
          //flag = !flag;
          if (item is HeaderItem){
            //flag = true;
            return DateItemRow(item.date);
          }else if (item is DocumentListItem){
            //flag = !flag;
            return DocumentItemRow(item.document, ColorUtils.getItemBgColor1(context),(item) async {
              await Navigator.of(context).pushNamed(
                  Pages.save_document, arguments: {'item': item});
              context.read<DocumentsHistoryCubit>().loadItems();
            }, (item){});
          }else if (item is PaymentListItem){
            return Padding(padding: EdgeInsets.symmetric(vertical: 1), child: PaymentItemRow(item.payment, ColorUtils.getItemBgColor2(context), (item) async{
              await Navigator.of(context).pushNamed(
                  Pages.save_payment, arguments: {'item': item});
              context.read<DocumentsHistoryCubit>().loadItems();
            }, (item){}),);
          }
          else{
            return SizedBox();
          }

        },
        itemCount: data.items.length);
  }
}