import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/home/home_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_customer_repository.dart';
import 'package:good_manager/data/repositories/data_document_repository.dart';
import 'package:good_manager/data/repositories/data_document_transaction_repository.dart';
import 'package:good_manager/data/repositories/data_expense_repository.dart';
import 'package:good_manager/data/repositories/data_good_repository.dart';
import 'package:good_manager/data/repositories/data_store_repository.dart';
import 'package:good_manager/data/repositories/data_supplier_repository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sprintf/sprintf.dart';

class HomePage extends View {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageView createState() => HomePageView();
}

class HomePageView extends ViewState<HomePage, HomeController> {
  static const titleStyle = TextStyle(color: Colors.blue, fontSize: 16);
  static const bodyStyle = TextStyle(fontSize: 16);

  HomePageView()
      : super(HomeController(
            DataStoreRepository(),
            DataGoodRepository(),
            DataDocumentRepository(),
            DataDocumentTransactionRepository(),
            DataSupplierRepository(),
            DataCustomerRepository(),
            DataExpenseRepository()));

  double height = 150;
  double iconSize = 40;

  @override
  Widget get view => Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<HomeController>(
          builder: (context, controller) {
        return ModalProgressHUD(
            child: getBody(), inAsyncCall: controller.isLoading, opacity: 0);
      }));

  Widget getBody() {
    List<Widget> children = [
      storeView,
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
                      child: goods,
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: documents,
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
                            child: incomingDocument,
                            flex: 1,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: outgoingDocument,
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
                            child: suppliers,
                            flex: 1,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: customers,
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
                      child: expenses,
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: height,
                      child: report,
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

  Widget get storeView =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return GestureDetector(
            onTap: controller.openStores,
            child: Container(
                height: 40,
                color: UIConstants.primaryDarkColor,
                width: double.infinity,
                child: Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(controller.info.storeName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )))
                ])));
      });

  Widget get goods =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openGoods,
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    UIConstants.goodIconPath,
                    width: iconSize,
                  ),
                  Text(AppLocalizations.of(context).goods_title,
                      style: titleStyle),
                  Text(
                      sprintf("%d/%d", [
                        controller.info.countGood,
                        controller.info.quantityGood
                      ]),
                      style: bodyStyle),
                ],
              )),
        ));
      });

  Widget get documents =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openDocuments,
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    UIConstants.documentIconPath,
                    width: iconSize,
                  ),
                  Text(AppLocalizations.of(context).documents_title,
                      style: titleStyle),
                  Text(controller.info.countDocument.toString(),
                      style: bodyStyle),
                ],
              )),
        ));
      });

  Widget get incomingDocument =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openSaveIncomingDocument,
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/add_incoming_document.png",
                    width: iconSize,
                  ),
                  Text(AppLocalizations.of(context).incoming_goods,
                      style: titleStyle)
                ],
              )),
        ));
      });

  Widget get outgoingDocument =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openSaveOutgoingDocument,
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/add_outgoing_document.png",
                    width: iconSize,
                  ),
                  Text(AppLocalizations.of(context).outgoing_goods,
                      style: titleStyle)
                ],
              )),
        ));
      });

  Widget get customers =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openCustomers,
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
                      Text(AppLocalizations.of(context).customers_title,
                          style: titleStyle),
                      Text(sprintf("(%d)", [controller.info.countCustomer]),
                          style: bodyStyle)
                    ],
                  )
                ],
              )),
        ));
      });

  Widget get suppliers =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openSuppliers,
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
                      Text(AppLocalizations.of(context).suppliers_title,
                          style: titleStyle),
                      Text(sprintf("(%d)", [controller.info.countSupplier]),
                          style: bodyStyle),
                    ],
                  )
                ],
              )),
        ));
      });

  Widget get expenses =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openExpenses,
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    UIConstants.expenseIconPath,
                    width: iconSize,
                  ),
                  Text(AppLocalizations.of(context).expenses_title,
                      style: titleStyle),
                  Text(
                    controller.info.sumExpense.toString(),
                    style: bodyStyle,
                  ),
                ],
              )),
        ));
      });

  Widget get report =>
      ControlledWidgetBuilder<HomeController>(builder: (context, controller) {
        return Card(
            child: InkWell(
          onTap: controller.openReport,
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    UIConstants.reportIconPath,
                    width: iconSize,
                  ),
                  Text(AppLocalizations.of(context).report_title,
                      style: titleStyle),
                ],
              )),
        ));
      });
}
