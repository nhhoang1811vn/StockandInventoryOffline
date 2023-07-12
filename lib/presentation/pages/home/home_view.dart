import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/base/base_page.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_data.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_state.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:sprintf/sprintf.dart';

import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BasePageState<HomePage, HomeCubit, HomeData> {
  static const titleStyle = TextStyle(color: Colors.blue, fontSize: 16);
  static const bodyStyle = TextStyle(fontSize: 16);

  @override
  void onDataChange(BuildContext context, HomeData data) {
    if (data.state is OpenSupplierState){
      Navigator.of(context).pushNamed(Pages.supplier_list, arguments: {'isSelection': false});
    }else if (data.state is OpenCustomersState){
      Navigator.of(context).pushNamed(Pages.customer_list, arguments: {'isSelection': false});
    }
    super.onDataChange(context, data);
  }

  double height = 150;
  double iconSize = 40;

  Widget _buildBody(HomeData data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(HomeData data) {
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
                      child: _buildGoods(data),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: _buildDocuments(data),
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
                            child: _buildSuppliers(data),
                            flex: 1,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: _buildCustomers(data),
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
                      child: _buildExpenses(data),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: _buildReport(data),
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

  Widget _buildGoods(HomeData data) {
    return Card(
        child: InkWell(
      onTap: cubit.openGoods,
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
              Text(sprintf("%d/%d", [data.info.countGood, data.info.quantityGood]), style: bodyStyle),
            ],
          )),
    ));
  }

  Widget _buildDocuments(HomeData data) {
    return Card(
        child: InkWell(
      onTap: cubit.openDocuments,
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
              Text(data.info.countDocument.toString(), style: bodyStyle),
            ],
          )),
    ));
  }

  Widget _buildIncomingDocument() {
    return Card(
        child: InkWell(
      onTap: cubit.openSaveIncomingDocument,
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

  Widget _buildOutgoingDocument() {
    return Card(
        child: InkWell(
      onTap: cubit.openSaveOutgoingDocument,
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

  Widget _buildCustomers(HomeData data) {
    return Card(
        child: InkWell(
      onTap: cubit.openCustomers,
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
                  Text(sprintf("(%d)", [data.info.countCustomer]), style: bodyStyle)
                ],
              )
            ],
          )),
    ));
  }

  Widget _buildSuppliers(HomeData data) {
    return Card(
        child: InkWell(
      onTap: cubit.openSuppliers,
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
                  Text(sprintf("(%d)", [data.info.countSupplier]), style: bodyStyle),
                ],
              )
            ],
          )),
    ));
  }

  Widget _buildExpenses(HomeData data) {
    return Card(
        child: InkWell(
      onTap: cubit.openExpenses,
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
                data.info.sumExpense.toString(),
                style: bodyStyle,
              ),
            ],
          )),
    ));
  }

  Widget _buildReport(HomeData data) {
    return Card(
        child: InkWell(
      onTap: cubit.openReport,
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

  @override
  Widget buildPage(BuildContext context, HomeData data) {
    return Scaffold(
        //key: globalKey,
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.home_title)),
        drawer: CustomNavigationDrawer(selectedIndex: 0),
        body: _buildBody(data));
  }
}
