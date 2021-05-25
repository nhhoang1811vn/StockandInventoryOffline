import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/document.dart';

import '../pages.dart';
import 'add_document_dialog.dart';

class DocumentsController extends Controller {
  bool isLoadingAll = true;
  List<Document> allDocuments = [];

  @override
  void initListeners() {}

  Future<void> onAddDocument(index) async {
    switch (index) {
      case 0:
        showDialog(
            context: getContext(),
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
    Document item = Document();
    //document.name = await presenter.getAutoDocumentName();
    item.name = "name";
    item.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    item.type = type;
    //arguments.document = document;
    var result = await Navigator.of(getContext()).pushNamed(Pages.save_document,
        arguments: {'isInsert': true, 'item': item});
    //if (result) {
    // screenUpdated();
    //}
  }
}
