import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/main.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:sprintf/sprintf.dart';

import '../../../domain/entities/document.dart';
import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const titleStyle = TextStyle(color: Colors.blue, fontSize: 16);
  static const bodyStyle = TextStyle(fontSize: 16);
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().initState();
  }
  @override
  Widget build(BuildContext context){
    return BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async{
          /*if (state.state is OpenGoodsState){
            Navigator.of(context).pushNamed(Pages.good_list, arguments: {'isSelection': false});
          } else if (state.state is OpenSuppliersState){
            Navigator.of(context).pushNamed(Pages.supplier_list, arguments: {'isSelection': false});
          }else if (state.state is OpenCustomersState){
            Navigator.of(context).pushNamed(Pages.customer_list, arguments: {'isSelection': false});
          }else if (state.state is OpenExpensesState){
            Navigator.of(context).pushNamed(Pages.expenses);
          }*/
        },
        builder: (context, state) =>  Scaffold(
          resizeToAvoidBottomInset: false,
            drawer: CustomNavigationDrawer(selectedIndex: 0, storeName: storage.getSelectedStoreName()),
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.home_title)),
            body: _buildBody(state),
        ));
  }

  double height = 150;
  double iconSize = 40;

  Widget _buildBody(HomeState state) {
    final state1 = state.state;
    if (state1 is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(state);
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(HomeState state) {
    List<Widget> children = [
      SelectedStoreView(),
      Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: _buildGoods(state),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: _buildDocuments(state),
                    ),
                    flex: 1,
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: _buildIncomingDocument(),
                            flex: 1,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: _buildOutgoingDocument(),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: _buildSuppliers(state),
                            flex: 1,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: _buildCustomers(state),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: _buildExpenses(state),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: _buildReport(state),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ],
          ))
    ];
    return Column(children: children);
  }

  Widget _buildGoods(HomeState state) {
    return Card(
        child: InkWell(
      onTap: openGoods,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                UIConstants.goodIconPath,
                width: iconSize,
              ),
              Text(AppLocalizations.of(context)!.goods_title, style: titleStyle),
              Text(sprintf("%d/%d", [state.countGood, state.quantityGood]), style: bodyStyle),
            ],
          )),
    ));
  }
  void openGoods(){
    Navigator.of(context).pushNamed(Pages.good_list, arguments: {'isSelection': false});
  }

  Widget _buildDocuments(HomeState state) {
    return Card(
        child: InkWell(
      onTap: openDocuments,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                UIConstants.documentIconPath,
                width: iconSize,
              ),
              Text(AppLocalizations.of(context)!.documents_title, style: titleStyle),
              Text(state.countDocument.toString(), style: bodyStyle),
            ],
          )),
    ));
  }
  void openDocuments(){
    Navigator.of(context).pushNamed(Pages.document_list);
  }

  Widget _buildIncomingDocument() {
    return Card(
        child: InkWell(
      onTap: openSaveIncomingDocument,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/add_incoming_document.png",
                width: iconSize,
              ),
              Text(AppLocalizations.of(context)!.incoming_goods, style: titleStyle)
            ],
          )),
    ));
  }
  void openSaveIncomingDocument() async{
    int storeId = storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.incoming;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    var result = await Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});

  }

  Widget _buildOutgoingDocument() {
    return Card(
        child: InkWell(
      onTap: openSaveOutgoingDocument,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/add_outgoing_document.png",
                width: iconSize,
              ),
              Text(AppLocalizations.of(context)!.outgoing_goods, style: titleStyle)
            ],
          )),
    ));
  }
  void openSaveOutgoingDocument() async{
    int storeId = storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.outgoing;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    var result = await Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
  }

  Widget _buildCustomers(HomeState state) {
    return Card(
        child: InkWell(
      onTap: openCustomers,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/customer.png",
                width: iconSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.customers_title, style: titleStyle),
                  Text(sprintf("(%d)", [state.countCustomer]), style: bodyStyle)
                ],
              )
            ],
          )),
    ));
  }
  void openCustomer(){
    //Navigator.of(context).pushNamed(Pages.customer_list, arguments: {'isSelection': false});
  }

  Widget _buildSuppliers(HomeState state) {
    return Card(
        child: InkWell(
      onTap: openSuppliers,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/supplier.png",
                width: iconSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.suppliers_title, style: titleStyle),
                  Text(sprintf("(%d)", [state.countSupplier]), style: bodyStyle),
                ],
              )
            ],
          )),
    ));
  }
  void openSuppliers(){
    Navigator.of(context).pushReplacementNamed(Pages.supplier_list, arguments: {});
  }
  void openCustomers(){
    Navigator.of(context).pushReplacementNamed(Pages.customer_list);
  }
  void openReport(){

  }

  Widget _buildExpenses(HomeState state) {
    return Card(
        child: InkWell(
      onTap: openExpenses,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                UIConstants.expenseIconPath,
                width: iconSize,
              ),
              Text(AppLocalizations.of(context)!.expenses_title, style: titleStyle),
              Text(
                state.sumExpense.toString(),
                style: bodyStyle,
              ),
            ],
          )),
    ));
  }
  void openExpenses(){
    Navigator.of(context).pushReplacementNamed(Pages.expenses);
  }

  Widget _buildReport(HomeState state) {
    return Card(
        child: InkWell(
      onTap: openReport,
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                UIConstants.reportIconPath,
                width: iconSize,
              ),
              Text(AppLocalizations.of(context)!.report_title, style: titleStyle),
            ],
          )),
    ));
  }
}
