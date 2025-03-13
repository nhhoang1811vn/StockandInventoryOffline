import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/expense_report_chart/expense_report_chart_widget.dart';
import 'package:good_manager/presentation/widgets/logo_app_bar.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../../domain/entities/document.dart';
import '../../widgets/sale_report/sale_report_widget.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onOpenGoodsPage;
  final VoidCallback onOpenDocumentsPage;
  HomePage({required this.onOpenGoodsPage, required this.onOpenDocumentsPage, required Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseStateWidget<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().initState();
  }

  @override
  bool hasDrawer() {
    return true;
  }

  @override
  Widget buildWidget(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {},
        builder: (context, state) => Scaffold(
              key: ScaffoldKey,
              resizeToAvoidBottomInset: false,
              appBar: LogoAppBar(),
              body: _buildBody(state),
            ));
  }
  double iconSize = 20;

  Widget _buildBody(HomeState state) {
    //final state1 = state.state;
    //if (state1 is LoadingState) {
    //  return _buildLoading();
    //}
    return _buildContent(state);
  }

  // Widget _buildLoading() {
  //   return const Center(
  //     child: CircularProgressIndicator(),
  //   );
  // }

  Widget _buildContent(HomeState state) {
    List<Widget> children = [
      SelectedStoreView(),
      Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildGoods(state),
              SizedBox(height: 16),
              _buildNewDocuments(state),
              SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildSingleValueCard(AppLocalizations.of(context)!.suppliers_title, state.countSupplier.toString(), UIConstants.supplierIconData, Colors.pink[50],Colors.pink[700], openSuppliers)),
                SizedBox(width: 16),
                Expanded(child: _buildSingleValueCard(AppLocalizations.of(context)!.customers_title, state.countCustomer.toString(), UIConstants.customerIconData,Colors.purple[50],Colors.purple[700], openCustomers)),
              ],),
              SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildSingleValueCard(AppLocalizations.of(context)!.expenses_title, Config.currencyFormat.format(state.sumExpense),UIConstants.expenseIconData, Colors.yellow[50],Colors.yellow[700], openExpenses)),
                SizedBox(width: 16),
                Expanded(child: _buildSingleValueCard(AppLocalizations.of(context)!.report_title, "", UIConstants.reportIconData, Colors.green[50],Colors.green[700], openReport))
              ],),
              SizedBox(height: 16),
              SaleReportWidget(),
              SizedBox(height: 16),
              ExpenseReportChartWidget()
            ],
          )),
    ];
    return SingleChildScrollView(child: Column(children: children));
  }

  Widget _buildGoods(HomeState state) {
    return Card(
        color: Colors.blue[50],
        child: InkWell(
          onTap: widget.onOpenGoodsPage,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.goods_title, style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 4,),
                    Text("${state.countGoods} items", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Quantity ${Utils.getQuantityText(state.quantityTotal)}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

                  ],
                )),
                Image(image: AssetImage('assets/images/box.png'), width: 24),
              ],
            ),
          ),
        ));
  }

  //void openGoods() {
  //  Navigator.of(context).pushNamed(Pages.good_list,
  //      arguments: {'isSelection': false}).then((value) => context.read<HomeCubit>().initState());
  //}
  Widget _buildNewDocuments(HomeState state){
    return Card(
        color: Colors.orange[50],
        child: InkWell(
          onTap: widget.onOpenDocumentsPage,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children:[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.documents_title, style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(
                              height: 4,
                            ),
                            Row(children: [
                              Expanded(child:    IntrinsicHeight(
                                child: Row(children: [
                                  SizedBox(
                                    width: 6,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red, // Change color as need,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                    Text("Incoming", style: Theme.of(context).textTheme.bodySmall,),
                                    Text("${state.countIncomingDocument}", style: Theme.of(context).textTheme.titleMedium),
                                    Text("${Config.currencyFormat.format(state.sumPriceIncomingDocument)}",  style: Theme.of(context).textTheme.titleMedium)
                                  ],)
                                ],),
                              ),),
                              SizedBox(width: 32,),
                              Expanded(child:    IntrinsicHeight(
                                child: Row(children: [
                                  SizedBox(
                                    width: 6,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green, // Change color as need,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                    Text("Outgoing", style: Theme.of(context).textTheme.bodySmall,),
                                    Text("${state.countOutgoingDocument}", style: Theme.of(context).textTheme.titleMedium),
                                    Text("${Config.currencyFormat.format(state.sumPriceOutgoingDocument)}",  style: Theme.of(context).textTheme.titleMedium)
                                  ],)
                                ],),
                              ),)
                            ],),

                            SizedBox(
                              height: 4,
                            ),

                          ],
                        )),
                    Image(image: AssetImage('assets/images/document.png'), width: 24),
                    //Icon(UIConstants.documentIconData, size: iconSize, color: Colors.orange[700]),
                  ],
                ),
                Row(children: [
                  Expanded(child: ElevatedButton.icon(
                    onPressed: openSaveIncomingDocument,
                    icon: Icon(Icons.add_circle_rounded), // Left icon
                    label: Text("New incoming"), // Text on the right
                  )),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(child: ElevatedButton.icon(
                    onPressed: openSaveOutgoingDocument,
                    icon: Icon(Icons.remove_circle_rounded), // Left icon
                    label: Text("New outgoing"), // Text on the right
                  )),
                ],)
              ]
            ),
          ),
        ));
  }
  //void openDocuments() {
  //  Navigator.of(context).pushNamed(Pages.document_list).then((value) => context.read<HomeCubit>().initState());
  //}

  void openSaveIncomingDocument() async {
    int storeId = storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.incoming;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    Navigator.of(context).pushNamed(Pages.save_document,
        arguments: {'item': item}).then((value) => context.read<HomeCubit>().initState());
  }



  void openSaveOutgoingDocument() async {
    int storeId = storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.outgoing;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    Navigator.of(context).pushNamed(Pages.save_document,
        arguments: {'item': item}).then((value) => context.read<HomeCubit>().initState());
  }

  void openSuppliers() {
    Navigator.of(context).pushNamed(Pages.supplier_list).then((value) => context.read<HomeCubit>().initState());
    ;
  }

  void openCustomers() {
    Navigator.of(context).pushNamed(Pages.customer_list).then((value) => context.read<HomeCubit>().initState());
    ;
  }

  void openReport() {
    Navigator.of(context).pushNamed(Pages.report);
  }
  Widget _buildSingleValueCard(String title, String value, IconData icon, Color? bgColor, Color? iconColor, VoidCallback onTap){
    return Card(
        color: bgColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(
                          height: 4,
                        ),
                        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    )),
                Icon(icon, size: iconSize, color: iconColor),
              ],
            ),
          ),
        ));
  }

  void openExpenses() {
    Navigator.of(context).pushNamed(Pages.expenses).then((value) => context.read<HomeCubit>().initState());
  }
}
