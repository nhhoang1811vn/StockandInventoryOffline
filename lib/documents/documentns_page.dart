import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
        child: Scaffold(
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
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            buttonSize: 56.0,
            visible: true,
            closeManually: false,
            renderOverlay: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                  label: 'Tạo GD Nhập',
                  onTap: () => _onAddIncomingDocument()),
              SpeedDialChild(
                  child: Icon(Icons.remove, color: Colors.grey),
                  backgroundColor: Colors.white,
                  label: 'Tạo GD Xuất',
                  onTap: () => _onAddOutgoingDocument())
            ],
          ),
        ));
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
    SaveDocumentPageArguments arguments =
    SaveDocumentPageArguments();
    arguments.document = document;
    var result = await Navigator.of(context).pushNamed(SaveDocumentPageWidget.routeName,
        arguments: arguments);
    if (result){
      screenUpdated();
    }
  }

  void onDocumentLongPressed(Document document) {}

  @override
  void screenUpdated() {
    setState(() {});
  }

  void _onAddIncomingDocument() async {
    SaveDocumentPageArguments arguments =
        SaveDocumentPageArguments();
    Document document = Document();
    document.storeId = await AppUtils.getSelectedStoreId();
    document.type = DocumentType.incoming;
    arguments.document = document;
    var result = await Navigator.of(context).pushNamed(SaveDocumentPageWidget.routeName,
        arguments: arguments);
    if (result){
      screenUpdated();
    }
  }

  void _onAddOutgoingDocument() async {
    SaveDocumentPageArguments arguments =
    SaveDocumentPageArguments();
    Document document = Document();
    document.storeId = await AppUtils.getSelectedStoreId();
    document.type = DocumentType.outgoing;
    arguments.document = document;
    var result = await Navigator.of(context).pushNamed(SaveDocumentPageWidget.routeName,
        arguments: arguments);
    if (result){
      screenUpdated();
    }
  }
}
