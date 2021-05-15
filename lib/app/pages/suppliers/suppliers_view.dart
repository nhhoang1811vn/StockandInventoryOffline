import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_document_repository.dart';
import 'package:good_manager/data/repositories/data_supplier_repository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

enum SupplierItemMenu { sendEmail, sendSMS, phoneCall, viewTransaction, delete }

class SuppliersPage extends View {
  final bool isSelection;

  SuppliersPage({Key key, @required this.isSelection});

  @override
  SuppliersPageView createState() => SuppliersPageView(SuppliersController(
      DataSupplierRepository(), DataDocumentRepository(), isSelection));
}

class SuppliersPageView extends ViewState<SuppliersPage, SuppliersController> {
  SearchBar searchBar;
  SuppliersController controller;

  SuppliersPageView(this.controller) : super(controller) {
    searchBar = new SearchBar(
      inBar: true,
      setState: setState,
      onCleared: onSearchBarCleared,
      onChanged: onSearchBarChanged,
      onClosed: onSearchBarClosed,
      controller: controller.searchTextController,
      buildDefaultAppBar: buildAppBar,
    );
  }

  @override
  Widget get view {
    return Scaffold(
        key: globalKey,
        appBar: searchBar.build(context),
        body: ControlledWidgetBuilder<SuppliersController>(
            builder: (context, controller) {
          return ModalProgressHUD(
              child: stackView, inAsyncCall: controller.isLoading, opacity: 0);
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.onAddItem(),
          child: Icon(Icons.add),
        ));
  }

  Widget get stackView => Stack(fit: StackFit.expand, children: [
        //emptyView,
        Visibility(
          child: emptyView,
          visible: controller.filteredItems.isEmpty,
        ),
        Visibility(
          child: listView,
          visible: controller.filteredItems.isNotEmpty,
        ),
      ]);

  Widget get emptyView => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.person,
              size: 60,
            ),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Khong co NCC nao ca', textAlign: TextAlign.center))
          ]);

  Widget get listView {
    return ControlledWidgetBuilder<SuppliersController>(
        builder: (context, controller) {
      return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                    '${controller.filteredItems[index].name[0].toUpperCase()}'),
              ),
              title: Text(controller.filteredItems[index].name),
              subtitle: Text(controller.filteredItems[index].description),
              onTap: () =>
                  controller.onItemPressed(controller.filteredItems[index]),
              trailing: PopupMenuButton<SupplierItemMenu>(
                onSelected: (SupplierItemMenu result) {
                  switch (result) {
                    case SupplierItemMenu.sendEmail:
                      _launchURL(
                          "mailto:${controller.filteredItems[index].email}");
                      break;
                    case SupplierItemMenu.sendSMS:
                      _launchURL(
                          "sms:${controller.filteredItems[index].phone}");
                      break;
                    case SupplierItemMenu.phoneCall:
                      _launchURL(
                          "tel:${controller.filteredItems[index].phone}");
                      break;
                    case SupplierItemMenu.viewTransaction:

                      ///TODO
                      break;
                    case SupplierItemMenu.delete:
                      controller.delete(controller.filteredItems[index].id);
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext a) =>
                    <PopupMenuEntry<SupplierItemMenu>>[
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.sendEmail,
                      child:
                          Text(AppLocalizations.of(context).action_send_email)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.sendSMS,
                      child:
                          Text(AppLocalizations.of(context).action_send_sms)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.phoneCall,
                      child:
                          Text(AppLocalizations.of(context).action_phone_call)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.viewTransaction,
                      child: Text(AppLocalizations.of(context)
                          .action_view_transaction)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.delete,
                      child: Text(AppLocalizations.of(context).action_delete))
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: controller.filteredItems.length);
    });
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  void onSearchBarChanged(String value) {
    controller.setTextSearch(value);
  }

  void onSearchBarCleared() {
    controller.setTextSearch("");
  }

  void onSearchBarClosed() {
    controller.setTextSearch("");
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(AppLocalizations.of(context).suppliers_title),
        actions: [
          searchBar.getSearchAction(context),
          ControlledWidgetBuilder<SuppliersController>(
              builder: (context, controller) {
            return Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: controller.isNoSort()
                    ? Icon(Icons.sort_by_alpha, size: 26)
                    : Icon(Icons.sort_by_alpha,
                        size: 26, color: UIConstants.primaryDarkColor),
                onTap: () => controller.openSortByDialog(),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(
                Icons.help,
                size: 26,
              ),
              onTap: () => controller.openHelpPage(),
            ),
          )
        ]);
  }
}
