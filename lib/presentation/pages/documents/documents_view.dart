import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/main.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/presentation/pages/custom_navigation_drawer.dart';
import 'package:sprintf/sprintf.dart';

import '../../../app/widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'add_document_dialog.dart';
import 'bloc/documents_cubit.dart';
import 'document_item_row.dart';

class DocumentsPage extends StatefulWidget {
  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentsPage> {
  @override
  void initState() {
    context.read<DocumentsCubit>().initState();
    super.initState();
  }
  Widget _buildAllDocumentView(DocumentsState state) {
    return getAllBody(state);
  }

  Widget getAllBody(DocumentsState state) {
    List<Widget> children = [
      Expanded(
          child: Stack(children: [
        Visibility(
          child: _buildAllEmptyView(state),
          visible: state.items.isEmpty,
        ),
        Visibility(
          child: _buildAllListView(state),
          visible: state.items.isNotEmpty,
        )
      ]))
    ];
    return Column(children: children);
  }

  Widget _buildIncomingDocumentView(BuildContext context, DocumentsState state) => Stack(
        children: [_buildIncomingEmptyView(context, state), _buildIncomingListView(state)],
      );

  Widget _buildOutgoingDocumentView(BuildContext context, DocumentsState state) => Stack(
        children: [_buildOutgoingEmptyView(context, state), _buildOutgoingListView(state)],
      );
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(builder: (context, state) =>
        DefaultTabController(
            length: 3,
            child: Builder(builder: (BuildContext context) {
              return Scaffold(
                  drawer: CustomNavigationDrawer(selectedIndex: 2, storeName: storage.getSelectedStoreName()),
                  appBar: _buildAppBar(state),
                  body: TabBarView(
                        children: [
                          _buildAllDocumentView(state),
                          _buildIncomingDocumentView(context, state),
                          _buildOutgoingDocumentView(context, state),
                        ]
                    )
                  ,
                  floatingActionButton:  FloatingActionButton(
                    onPressed: () => onAddDocument(DefaultTabController.of(context).index),
                    child: Icon(Icons.add),
                    backgroundColor: Colors.blue,
                  ));

            }))
        , listener: (context, state){
          if (state.state is OpenHelpPageState){
            String code = storage.getLanguageCode();
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)!.documents_title,
              "content": HelpUtils.getMarkdownData(code, HelpType.DOCUMENTS)
            });
          }else if (state.state is OpenSortDialogListState){

          }
        });
  }
  void _onAddDocumentWithType(DocumentType type) async {
    int storeId =   storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = type;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();

    var result = await Navigator.of(context)
        .pushNamed(Pages.save_document, arguments: {'item': item});
    /*if (result != null) {
      allDocuments.add(result);
      refreshItems();
    }*/
  }
  void onAddDocument(int index) async{
    switch (index) {
      case 0:
        DocumentType? type = await showDialog(
            context: context,
            builder: (_) => AddDocumentDialogWidget(),
            barrierDismissible: true);
        if (type != null){
          _onAddDocumentWithType(type);
        }
        break;
      case 1:
        _onAddDocumentWithType(DocumentType.incoming);
        break;
      case 2:
        _onAddDocumentWithType(DocumentType.outgoing);
        break;
    }
  }

  PreferredSize _buildAppBar(DocumentsState state) {
    return PreferredSize(
        preferredSize:Size.fromHeight(58.0 + 20 + 58.0 + (state.showSearchBar ? 65 : 0)),
        child: AppBar(
          actions: [_buildSearchMenu(state), _buildSortMenu(state), helpMenu],
          title: Text(AppLocalizations.of(context)!.documents_title),
          bottom: PreferredSize(preferredSize: Size.fromHeight(20 + 58 + (state.showSearchBar ? 65 : 0)), child: Column(children: [
            SelectedStoreView(),
            Visibility(child: _buildSearchBar(context, state), visible: state.showSearchBar),
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

          ],),),
        ),
    );
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

  Widget _buildAllEmptyView(DocumentsState state) => Visibility(
      visible: state.items.isEmpty,
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
              child: Text(AppLocalizations.of(context)!.empty_document, textAlign: TextAlign.center))
        ],
      ));

  Widget _buildIncomingEmptyView(BuildContext context, DocumentsState state) => Visibility(
      visible: state.incomingItems.isEmpty,
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
              child: Text(AppLocalizations.of(context)!.empty_incoming_document, textAlign: TextAlign.center))
        ],
      ));

  Widget _buildOutgoingEmptyView(BuildContext context, DocumentsState state) => Visibility(
      visible: state.outgoingItems.isEmpty,
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
              child: Text(AppLocalizations.of(context)!.empty_outgoing_document, textAlign: TextAlign.center))
        ],
      ));

  Widget _buildAllListView(DocumentsState state) => Visibility(
      visible: state.items.isNotEmpty,
      child: ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Document item = state.items[index];
            return DocumentItemRow(true, item, (item) => onPressedDocument(item),
                (item) => onLongPressedDocument(item));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: state.items.length));

  Widget _buildIncomingListView(DocumentsState state) => Visibility(
      visible: state.incomingItems.isNotEmpty,
      child: ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Document item = state.incomingItems[index];
            return DocumentItemRow(false, item, (item) => onPressedDocument(item),
                (item) => onLongPressedDocument(item));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: state.incomingItems.length));

  Widget _buildOutgoingListView(DocumentsState state) => Visibility(
      visible: state.outgoingItems.isNotEmpty,
      child: ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Document item = state.outgoingItems[index];
            return DocumentItemRow(false, item, (item) => onPressedDocument(item),
                (item) => onLongPressedDocument(item));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: state.outgoingItems.length));

  Widget _buildSearchMenu(DocumentsState state) => Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          child: Icon(
            UIConstants.searchMenuIconData,
            size: 26,
            color: state.showSearchBar ? UIConstants.highlightMenuColor : UIConstants.normalMenuColor,
          ),
          onTap: () {
            context.read<DocumentsCubit>().toggleSearchBar();
          },
        ),
      );

  Widget _buildSortMenu(DocumentsState state) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: Icon(
          UIConstants.sortMenuIconData,
          size: 26,
          color: context.read<DocumentsCubit>().hasSortOptions()
              ? UIConstants.highlightMenuColor
              : UIConstants.normalMenuColor,
        ),
        onTap: context.read<DocumentsCubit>().onShowSortDialog,
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
          onTap: context.read<DocumentsCubit>().onOpenHelpPage,
        ),
      );

  Widget _buildSearchBar(BuildContext context, DocumentsState state) => Row(children: [
        Expanded(
            child: Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: state.settings.searchDocumentsType.getText(context), border: InputBorder.none),
              onChanged: context.read<DocumentsCubit>().onSearchChanged,
              //controller: controller.searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                icon: Icon(UIConstants.cancelIconData),
                onPressed: context.read<DocumentsCubit>().resetSearchText,
              ),
              visible: state.textSearch.isNotEmpty,
            ),
          ),
        )),
        PopupMenuButton<SearchDocumentsType>(
          itemBuilder: (BuildContext a) => <PopupMenuEntry<SearchDocumentsType>>[
            PopupMenuItem<SearchDocumentsType>(
                value: SearchDocumentsType.byName,
                child: Text(AppLocalizations.of(context)!.search_documents_type_by_name)),
            PopupMenuItem<SearchDocumentsType>(
                value: SearchDocumentsType.byDescription,
                child: Text(AppLocalizations.of(context)!.search_documents_type_by_description)),
            PopupMenuItem<SearchDocumentsType>(
                value: SearchDocumentsType.byCustomerSupplier,
                child: Text(AppLocalizations.of(context)!.search_documents_type_by_customer_supplier)),
          ],
          onSelected: context.read<DocumentsCubit>().setSearchDocumentsType,
        )
      ]);

  void onPressedDocument(Document item) async{
    var result = await Navigator.of(context)
        .pushNamed(Pages.save_document, arguments: {'item': item});
    /*if (result != null) {
      int index = allDocuments.indexWhere((element) => element.id == item.id);
      allDocuments[index] = result;
      refreshItems();
    }*/
  }
  void onLongPressedDocument(Document item){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteDocumentConfirm(item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }
  void showDeleteDocumentConfirm(Document document) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(context)!.message_confirm_delete,
                [document.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  //presenter.delete(document.id);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }
}
