import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/main_page.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_document_repository.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'document_item_row.dart';
import 'documents_controller.dart';

class DocumentsPage extends View {
  @override
  DocumentPageView createState() => DocumentPageView();
}

class DocumentPageView extends ViewState<DocumentsPage, DocumentsController> {
  DocumentPageView()
      : super(DocumentsController(
            DataDocumentRepository()));
  bool showSearchView = false;

  Widget get allDocumentView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return ModalProgressHUD(
            child: getAllBody(), inAsyncCall: controller.isLoading, opacity: 0);
      });

  Widget getAllBody() {
    List<Widget> children = [
      ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Expanded(
            child: Stack(children: [
          Visibility(
            child: allEmptyView,
            visible: controller.items.isEmpty && !controller.isLoading,
          ),
          Visibility(
            child: allListView,
            visible: controller.items.isNotEmpty,
          )
        ]));
      })
    ];
    return Column(children: children);
  }

  Widget get incomingDocumentView => Stack(
        children: [incomingEmptyView, incomingListView],
      );

  Widget get outgoingDocumentView => Stack(
        children: [outgoingEmptyView, outgoingListView],
      );

  @override
  Widget get view => DefaultTabController(
      key: globalKey,
      length: 3,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          drawer: CustomNavigationDrawer(),
            appBar: appBar,
            body: TabBarView(
              children: [
                allDocumentView,
                incomingDocumentView,
                outgoingDocumentView,
              ],
            ),
            floatingActionButton: ControlledWidgetBuilder<DocumentsController>(
                builder: (context, controller) {
              return FloatingActionButton(
                onPressed: () => controller
                    .onAddDocument(DefaultTabController.of(context).index),
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              );
            }));
      }));

  Widget get appBar => AppBar(
    title: Text(AppLocalizations.of(context).documents_title),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(showSearchView ? (74.0 + 65.0) : 74),
            child: Column(
              children: [
                Visibility(child: searchBar, visible: showSearchView),
                TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                        text:
                            AppLocalizations.of(context).document_list_tab_all),
                    Tab(
                        text: AppLocalizations.of(context)
                            .document_list_tab_incoming),
                    Tab(
                        text: AppLocalizations.of(context)
                            .document_list_tab_outgoing),
                  ],
                )
              ],
            )),
        actions: [searchMenu, sortMenu, helpMenu],
      );

  Widget get allEmptyView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.items.isEmpty && !controller.isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(
                      UIConstants.documentIconPath,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(AppLocalizations.of(context).empty_document,
                        textAlign: TextAlign.center))
              ],
            ));
      });

  Widget get incomingEmptyView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.incomingItems.isEmpty && !controller.isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(
                      UIConstants.documentIconPath,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                        AppLocalizations.of(context).empty_incoming_document,
                        textAlign: TextAlign.center))
              ],
            ));
      });

  Widget get outgoingEmptyView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.outgoingItems.isEmpty && !controller.isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(
                      UIConstants.documentIconPath,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                        AppLocalizations.of(context).empty_outgoing_document,
                        textAlign: TextAlign.center))
              ],
            ));
      });

  Widget get allListView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.items.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = controller.items[index];
                  return DocumentItemRow(
                      true,
                      item,
                      (item) => controller.onDocumentTapped(item),
                      (item) => controller.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: controller.items.length));
      });

  Widget get incomingListView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.incomingItems.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = controller.incomingItems[index];
                  return DocumentItemRow(
                      false,
                      item,
                      (item) => controller.onDocumentTapped(item),
                      (item) => controller.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: controller.incomingItems.length));
      });

  Widget get outgoingListView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.outgoingItems.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = controller.outgoingItems[index];
                  return DocumentItemRow(
                      false,
                      item,
                      (item) => controller.onDocumentTapped(item),
                      (item) => controller.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: controller.outgoingItems.length));
      });

  Widget get searchMenu => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: controller.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: () {
              controller.toggleSearchBar();
              setState(() {
                showSearchView = !showSearchView;
              });
            },
          ),
        );
      });

  Widget get sortMenu => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: controller.hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: controller.onShowSortDialog,
          ),
        );
      });

  Widget get helpMenu => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: controller.onOpenHelpPage,
          ),
        );
      });

  Widget get searchBar => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Row(children: [
          Expanded(
              child: Card(
            child: ListTile(
              title: TextField(
                decoration: InputDecoration(
                    hintText: controller.getSearchTextHint(),
                    border: InputBorder.none),
                onChanged: controller.onSearchChanged,
                controller: controller.searchTextController,
              ),
              trailing: Visibility(
                child: IconButton(
                  icon: Icon(UIConstants.cancelIconData),
                  onPressed: controller.resetSearchText,
                ),
                visible: controller.textSearch.isNotEmpty,
              ),
            ),
          )),
          PopupMenuButton<SearchDocumentsType>(
            itemBuilder: (BuildContext a) =>
                <PopupMenuEntry<SearchDocumentsType>>[
              PopupMenuItem<SearchDocumentsType>(
                  value: SearchDocumentsType.byName,
                  child: Text(AppLocalizations.of(context)
                      .search_documents_type_by_name)),
              PopupMenuItem<SearchDocumentsType>(
                  value: SearchDocumentsType.byDescription,
                  child: Text(AppLocalizations.of(context)
                      .search_documents_type_by_description)),
              PopupMenuItem<SearchDocumentsType>(
                  value: SearchDocumentsType.byCustomerSupplier,
                  child: Text(AppLocalizations.of(context)
                      .search_documents_type_by_customer_supplier)),
            ],
            onSelected: controller.setSearchDocumentsType,
          )
        ]);
      });
}
