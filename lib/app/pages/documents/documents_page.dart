import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/documents/save_document.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/Document.dart';

import 'add_document_dialog.dart';
import 'document_list_item.dart';
import 'documents_presenter.dart';

class DocumentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DocumentsPageState();
  }
}

class _DocumentsPageState extends State<DocumentsPage> {
  DocumentsPresenter presenter;

  @override
  void initState() {
    presenter = DocumentsPresenter();
    super.initState();
  }

  @override
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
  }
}
