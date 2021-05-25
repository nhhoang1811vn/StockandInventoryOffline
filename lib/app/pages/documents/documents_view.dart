import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'document_item_row.dart';
import 'documents_controller.dart';

class DocumentsPage extends View {
  @override
  DocumentPageView createState() => DocumentPageView();
}

class DocumentPageView extends ViewState<DocumentsPage, DocumentsController> {
  DocumentPageView() : super(DocumentsController());

  /*@override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Giao dịch'),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: AppLocalizations.of(context).document_list_tab_all),
                  Tab(
                      text: AppLocalizations.of(context)
                          .document_list_tab_incoming),
                  Tab(
                      text: AppLocalizations.of(context)
                          .document_list_tab_outgoing),
                  Tab(
                      text: AppLocalizations.of(context)
                          .document_list_tab_stock_taking),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                getDocumentFutureBuilder(presenter.getAllDocuments(), true),
                getDocumentFutureBuilder(
                    presenter.getIncomingDocuments(), false),
                getDocumentFutureBuilder(
                    presenter.getOutgoingDocuments(), false),
                getDocumentFutureBuilder(
                    presenter.getStockTakingDocuments(), false)
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _onAddDocument(context),
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          );
        }));
  }

  FutureBuilder getDocumentFutureBuilder(
      Future<List<Document>> source, bool showAll) {
    return new FutureBuilder<List<Document>>(
        future: source,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? new DocumentList(snapshot.data, (it) => onDocumentTapped(it),
                  (it) => onDocumentLongPressed(it), showAll)
              : new Center(child: new CircularProgressIndicator());
        });
  }

  void onDocumentTapped(Document document) async {
    SaveDocumentPageArguments arguments = SaveDocumentPageArguments();
    arguments.document = document;
    var result = await Navigator.of(context)
        .pushNamed(Pages.save_document, arguments: arguments);
    if (result) {
      screenUpdated();
    }
  }

  void onDocumentLongPressed(Document document) {}

  @override
  void screenUpdated() {
    setState(() {});
  }

  void _onAddDocument(BuildContext context) {
    switch (DefaultTabController.of(context).index) {
      case 0:
        showDialog(
            context: context,
            builder: (_) =>
                AddDocumentDialogWidget((it) => {_onAddDocumentWithType(it)}),
            barrierDismissible: true);
        break;
      case 1:
        _onAddDocumentWithType(DocumentType.incoming);
        break;
      case 2:
        _onAddDocumentWithType(DocumentType.outgoing);
        break;
      case 3:
        _onAddDocumentWithType(DocumentType.stock_taking);
        break;
    }
  }

  void _onAddDocumentWithType(DocumentType type) async {
    SaveDocumentPageArguments arguments = SaveDocumentPageArguments();
    Document document = Document();
    document.name = await presenter.getAutoDocumentName();
    document.storeId =
        await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    document.type = type;
    arguments.document = document;
    var result = await Navigator.of(context)
        .pushNamed(Pages.save_document, arguments: arguments);
    if (result) {
      screenUpdated();
    }
  }*/
  Widget get allDocumentView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return ModalProgressHUD(
            child: content, inAsyncCall: controller.isLoadingAll, opacity: 0);
      });

  @override
  Widget get view => DefaultTabController(
      key: globalKey,
      length: 4,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
            appBar: appBar,
            body: TabBarView(
              children: [
                allDocumentView,
                allDocumentView,
                allDocumentView,
                allDocumentView
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
        title: Text(AppLocalizations.of(context).title_document),
        bottom: TabBar(
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: AppLocalizations.of(context).document_list_tab_all),
            Tab(text: AppLocalizations.of(context).document_list_tab_incoming),
            Tab(text: AppLocalizations.of(context).document_list_tab_outgoing),
            Tab(
                text: AppLocalizations.of(context)
                    .document_list_tab_stock_taking),
          ],
        ),
      );

  Widget get emptyView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.allDocuments.isEmpty,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  UIConstants.documentsIconData,
                  size: 60,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(AppLocalizations.of(context).empty_document,
                        textAlign: TextAlign.center))
              ],
            ));
      });

  Widget get listView => ControlledWidgetBuilder<DocumentsController>(
          builder: (context, controller) {
        return Visibility(
            visible: controller.allDocuments.isNotEmpty,
            child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  Document item = controller.allDocuments[index];
                  return DocumentItemRow(
                      true, item, (item) => {}, (item) => {});
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: controller.allDocuments.length));
      });

  Widget get content => Stack(
        children: [emptyView, listView],
      );
}
