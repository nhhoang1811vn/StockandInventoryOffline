import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/base/base_page.dart';
import 'package:good_manager/presentation/pages/custom_navigation_drawer.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_data.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';

import 'bloc/documents_cubit.dart';
import 'document_item_row.dart';

class DocumentsPage extends StatefulWidget {
  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends BasePageState<DocumentsPage, DocumentsCubit, DocumentsData> {

  bool showSearchView = false;

  Widget _buildAllDocumentView(DocumentsData data){
    return getAllBody(data);
  }

  Widget getAllBody(DocumentsData data) {
    List<Widget> children = [
      Expanded(
            child: Stack(children: [
          Visibility(
            child: _buildAllEmptyView(data),
            visible: data.items.isEmpty,
          ),
          Visibility(
            child: _buildAllListView(data),
            visible: data.items.isNotEmpty,
          )
        ]))
    ];
    return Column(children: children);
  }

  Widget _buildIncomingDocumentView(BuildContext context, DocumentsData data) => Stack(
        children: [
          _buildIncomingEmptyView(context, data),
          _buildIncomingListView(data)
        ],
      );

  Widget _buildOutgoingDocumentView(BuildContext context, DocumentsData data) => Stack(
        children: [
          _buildOutgoingEmptyView(context, data),
          _buildOutgoingListView(data)
        ],
      );
  @override
  Widget buildPage(BuildContext context, DocumentsData data) {
    return DefaultTabController(
      //key: globalKey,
        length: 3,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
              drawer: CustomNavigationDrawer(selectedIndex: 2),
              appBar: _buildAppBar(),
              body:
              //SelectedStoreView(),
              TabBarView(
                  children: [
                    _buildAllDocumentView(data),
                    _buildIncomingDocumentView(context, data),
                    _buildOutgoingDocumentView(context, data),
                  ]
              )
              ,
              floatingActionButton:  FloatingActionButton(
                      onPressed: () => cubit.onAddDocument(DefaultTabController.of(context).index),
                      child: Icon(Icons.add),
                      backgroundColor: Colors.blue,
                    ));

        }));
  }
  PreferredSize _buildAppBar(){
    return PreferredSize(
        child: AppBar(title: Text(AppLocalizations.of(context)!.documents_title),),
        preferredSize : Size.fromHeight(70));
  }
  /*Widget get appBar => AppBar(
    title: Text(AppLocalizations.of(context)!.documents_title),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(showSearchView ? (74.0 + 65.0) : 74),
            child: Column(
              children: [
                SelectedStoreView(),
                Visibility(child: _buildSearchBar(context, data), visible: showSearchView),
                TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                        text:
                            AppLocalizations.of(context)!.document_list_tab_all),
                    Tab(
                        text: AppLocalizations.of(context)!
                            .document_list_tab_incoming),
                    Tab(
                        text: AppLocalizations.of(context)!
                            .document_list_tab_outgoing),
                  ],
                )
              ],
            )),
        actions: [searchMenu, sortMenu, helpMenu],
      );*/

  Widget _buildAllEmptyView(DocumentsData data) => Visibility(
            visible: data.items.isEmpty,
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
                    child: Text(AppLocalizations.of(context)!.empty_document,
                        textAlign: TextAlign.center))
              ],
            ));

  Widget _buildIncomingEmptyView(BuildContext context, DocumentsData data) =>  Visibility(
            visible: data.incomingItems.isEmpty,
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
                        AppLocalizations.of(context)!.empty_incoming_document,
                        textAlign: TextAlign.center))
              ],
            ));

  Widget _buildOutgoingEmptyView(BuildContext context, DocumentsData data) => Visibility(
            visible: data.outgoingItems.isEmpty,
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
                        AppLocalizations.of(context)!.empty_outgoing_document,
                        textAlign: TextAlign.center))
              ],
            ));

  Widget _buildAllListView(DocumentsData data) =>  Visibility(
            visible: data.items.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = data.items[index];
                  return DocumentItemRow(
                      true,
                      item,
                      (item) => cubit.onDocumentTapped(item),
                      (item) => cubit.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: data.items.length));

  Widget _buildIncomingListView(DocumentsData data) => Visibility(
            visible: data.incomingItems.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = data.incomingItems[index];
                  return DocumentItemRow(
                      false,
                      item,
                      (item) => cubit.onDocumentTapped(item),
                      (item) => cubit.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: data.incomingItems.length));


  Widget _buildOutgoingListView(DocumentsData data) => Visibility(
            visible: data.outgoingItems.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = data.outgoingItems[index];
                  return DocumentItemRow(
                      false,
                      item,
                      (item) => cubit.onDocumentTapped(item),
                      (item) => cubit.onDocumentLongPressed(item));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: data.outgoingItems.length));


  Widget _buildSearchMenu(DocumentsData data) => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: data.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: () {
              cubit.toggleSearchBar();
              setState(() {
                showSearchView = !showSearchView;
              });
            },
          ),
        );


  Widget _buildSortMenu(DocumentsData data) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: Icon(
          UIConstants.sortMenuIconData,
          size: 26,
          color: cubit.hasSortOptions()
              ? UIConstants.highlightMenuColor
              : UIConstants.normalMenuColor,
        ),
        onTap: cubit.onShowSortDialog,
      ),
    );
  }

  Widget get helpMenu => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: cubit.onOpenHelpPage,
          ),
        );


  Widget _buildSearchBar(BuildContext context, DocumentsData data) =>
      Row(children: [
          Expanded(
              child: Card(
            child: ListTile(
              title: TextField(
                decoration: InputDecoration(
                    hintText: data.settings.searchDocumentsType.getText(context),
                    border: InputBorder.none),
                onChanged: cubit.onSearchChanged,
                //controller: controller.searchTextController,
              ),
              trailing: Visibility(
                child: IconButton(
                  icon: Icon(UIConstants.cancelIconData),
                  onPressed: cubit.resetSearchText,
                ),
                visible: data.textSearch.isNotEmpty,
              ),
            ),
          )),
          PopupMenuButton<SearchDocumentsType>(
            itemBuilder: (BuildContext a) =>
                <PopupMenuEntry<SearchDocumentsType>>[
              PopupMenuItem<SearchDocumentsType>(
                  value: SearchDocumentsType.byName,
                  child: Text(AppLocalizations.of(context)!
                      .search_documents_type_by_name)),
              PopupMenuItem<SearchDocumentsType>(
                  value: SearchDocumentsType.byDescription,
                  child: Text(AppLocalizations.of(context)!
                      .search_documents_type_by_description)),
              PopupMenuItem<SearchDocumentsType>(
                  value: SearchDocumentsType.byCustomerSupplier,
                  child: Text(AppLocalizations.of(context)!
                      .search_documents_type_by_customer_supplier)),
            ],
            onSelected: cubit.setSearchDocumentsType,
          )
        ]);

}
