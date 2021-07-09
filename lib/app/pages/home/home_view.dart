import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/home/home_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../store_view.dart';

class HomePage extends View {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageView createState() => HomePageView();
}

class HomePageView extends ViewState<HomePage, HomeController> {
  HomePageView() : super(HomeController());

  @override
  Widget get view => Scaffold(
      key: globalKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).title_home),
      ),
      body: ControlledWidgetBuilder<HomeController>(
          builder: (context, controller) {
        return ModalProgressHUD(
            child: getBody(), inAsyncCall: controller.isLoading, opacity: 0);
      }));

  Widget getBody() {
    List<Widget> children = [
      StoreView(),
      Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 100,
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            UIConstants.goodIconPath,
                            width: 24,
                          ),
                          Text("Goods"),
                          Text("0/0"),
                        ],
                      )),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 100,
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            UIConstants.documentIconPath,
                            width: 24,
                          ),
                          Text("Documents"),
                          Text("0"),
                        ],
                      )),
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
                      height: 150,
                      child: Column(
                        children: [
                          Container(
                            height: 75,
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/add_incoming_document.png",
                                              width: 24,
                                            ),
                                            Text("Nhập hàng")
                                          ],
                                        )),
                                  ),
                                  flex: 1,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/add_outgoing_document.png",
                                              width: 24,
                                            ),
                                            Text("Xuất hàng")
                                          ],
                                        )),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 75,
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/supplier.png",
                                              width: 24,
                                            ),
                                            Text("NCC")
                                          ],
                                        )),
                                  ),
                                  flex: 1,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/customer.png",
                                              width: 24,
                                            ),
                                            Text("Khách hàng")
                                          ],
                                        )),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 150,
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            UIConstants.expenseIconPath,
                            width: 24,
                          ),
                          Text("Expenses"),
                          Text("50.000VND"),
                        ],
                      )),
                    ),
                    flex: 1,
                  ),
                ],
              )
            ],
          ))
    ];
    return Column(children: children);
  }
}
