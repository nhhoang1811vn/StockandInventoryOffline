import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/documents/add_document_dialog.dart';
import 'package:good_manager/documents/documents_presenter.dart';
import 'package:good_manager/documents/save_document.dart';
import 'package:good_manager/model/Document.dart';
import 'package:good_manager/utils/AppUtils.dart';

import 'document_list_item.dart';

class DocumentPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DocumentPageWidgetState();
  }
}

class _DocumentPageWidgetState extends State<DocumentPageWidget> {
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
                  Tab(text: 'TẤT CẢ'),
                  Tab(text: 'NHẬP'),
                  Tab(text: 'XUẤT'),
                  Tab(text: 'KIỂM KÊ'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                getDocumentFutureBuilder(presenter.getAllDocuments()),
                getDocumentFutureBuilder(presenter.getIncomingDocuments()),
                getDocumentFutureBuilder(presenter.getOutgoingDocuments()),
                getDocumentFutureBuilder(presenter.getStockTakingDocuments())
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

  FutureBuilder getDocumentFutureBuilder(Future<List<Document>> source) {
    return new FutureBuilder<List<Document>>(
        future: source,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? new DocumentList(snapshot.data, (it) => onDocumentTapped(it),
                  (it) => onDocumentLongPressed(it))
              : new Center(child: new CircularProgressIndicator());
        });
  }

  void onDocumentTapped(Document document) async {
    SaveDocumentPageArguments arguments = SaveDocumentPageArguments();
    arguments.document = document;
    var result = await Navigator.of(context)
        .pushNamed(SaveDocumentPageWidget.routeName, arguments: arguments);
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
    document.storeId = await AppUtils.getSelectedStoreId();
    document.type = type;
    arguments.document = document;
    var result = await Navigator.of(context)
        .pushNamed(SaveDocumentPageWidget.routeName, arguments: arguments);
    if (result) {
      screenUpdated();
    }
  }
}
